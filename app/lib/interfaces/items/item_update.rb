class Interfaces::Items::ItemUpdate 
  include StaffTracker::Recorder

  attr_reader :item

  def initialize item
    self.item = item
  end

  def update! params
    check_authorization

    Item.transaction do
      self.item.update!(params.except(:type_name))
      Item::ItemStocker.new(self.item).update_item_stock!
    end

    record(
      :update,
      "item",
      self.item.id
    )

    return self.item
  end

  private
  attr_writer :item

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_item?
  end
end