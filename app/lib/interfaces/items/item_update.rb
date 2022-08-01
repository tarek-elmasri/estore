class Interfaces::Items::ItemUpdate 
  include StaffTracker::Recorder

  attr_reader :item

  def initialize item
    self.item = item
  end

  def update! params
    check_authorization
    item.assign_attributes(params.except(:type_name))
    set_discount_state 
    Item.transaction do
      item.save!
      Item::ItemStocker.new(self.item).update_item_stock!
      create_discount_jobs
    end

    record(
      :update,
      "item",
      self.item.id
    )

    return self.item.reload
  end

  def update_discount_status! status
    item.update!(has_discount: status)
  end

  private
  attr_writer :item

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_item?
  end

  def set_discount_state
    return unless has_discount_dates?
    item.has_discount = should_activate_discount?
  end

  def create_discount_jobs
    return unless has_discount_dates?

    DiscountActivatorJob
                .set(wait_until: item.discount_start_date)
                .perform_later(item.id, :activate) unless item.has_discount?
    
    DiscountActivatorJob
                .set(wait_until: item.discount_end_date)
                .perform_later(item.id, :deactivate) if item.discount_end_date_previously_changed? 
  end

  # def discount_dates_previously_changed?
  #   item.discount_start_date_previously_changed? || item.discount_end_date_previously_changed?
  # end
  
  def has_discount_dates?
    item.discount_start_date? && item.discount_end_date?
  end
  
  def should_activate_discount?
    return false unless has_discount_dates?

    item.discount_start_date < DateTime.now && item.discount_end_date > DateTime.now
  end
end