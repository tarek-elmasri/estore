class CartManager::NewCart::Validations::Availability

  attr_accessor :cart

  def initialize cart
    self.cart=cart
  end


  def item_available? item_id
    return true if find_item(item_id)
    false
  end

  def item_quantity_available?(item_id, quantity)

  end


  private
  def find_item item_id
    Item.visible.find_by(id: item_id)
  end

end