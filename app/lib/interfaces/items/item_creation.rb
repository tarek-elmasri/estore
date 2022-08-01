class Interfaces::Items::ItemCreation 
  include StaffTracker::Recorder

  attr_reader :item

  def initialize params ={}
    self.item_params= params
    self.item= Item.new(params)
  end
  
  def create!
    check_authorization
    set_discount_state

    Item.transaction do
      # create is used to pass nested parameters attributes of item_categories
      self.item = Item.create!(item_params)
      Item::ItemStocker.new(self.item).update_item_stock!
      create_discount_jobs
    end

    record(
      :create,
      "item",
      self.item.id
    )

    return self.item.reload
  end

  private 
  attr_writer :item
  attr_accessor :item_params
  
  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_create_item?
  end

  def set_discount_state
    self.item_params[:has_discount] = should_activate_discount?
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