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

  private
  attr_writer :item

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_item?
  end

  def set_discount_state
    return unless discount_dates_changed?
    item.has_discount = should_activate_discount?
  end

  def discount_dates_changed?
    item.discount_start_date_changed? || item.discount_end_date_changed?
  end
  
  def create_discount_jobs
    return unless has_discount_dates?
    # create activate job if should_activate_discount?
    # create deactivate job
  end
  
  def has_discount_dates?
    item.discount_start_date? && item.discount_end_date?
  end
  
  def should_activate_discount?
    return false unless has_discount_dates?
    !item.has_discount? 
        && item.discount_start_date < DateTime.now
        && item.discount_end_date > DateTime.now
  end
end