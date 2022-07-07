class Interfaces::Items::ItemCreation 
  include Interfaces::Items::ItemStockHandler
  include StaffTracker::Recorder

  attr_reader :item

  def initialize params ={}
    self.item= Item.new(params)
  end
  
  def create!
    check_authorization
    self.item.stock = 0 if self.item.is_card?
    Item.transaction do
      self.item.save!
      update_item_stock!
    end

    record(
      :create,
      "item",
      self.item.id
    )

    return self.item
  end

  private 
  attr_writer :item

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_create_item?
  end

end