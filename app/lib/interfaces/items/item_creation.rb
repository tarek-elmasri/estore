class Interfaces::Items::ItemCreation 
  include StaffTracker::Recorder

  attr_reader :item

  def initialize params ={}
    self.item_params= params
    self.item= Item.new(params)
  end
  
  def create!
    check_authorization
    #self.item.stock = 0 if self.item.is_card?
    Item.transaction do
      # create is used to pass nested parameters attributes
      self.item = Item.create!(item_params)
      Item::ItemStocker.new(self.item).update_item_stock!
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
  attr_accessor :item_params
  
  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_create_item?
  end

end