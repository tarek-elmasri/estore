class Interfaces::CartItems::CartItemUpdate

  attr_reader :cart_item

  def initialize cart_item
    self.cart_item= cart_item
  end

  def update! params
    self.cart_item.update!(params)
  end

  private
  attr_writer :item_cart
    

end