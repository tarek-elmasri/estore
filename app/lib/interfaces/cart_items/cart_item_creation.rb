class Interfaces::CartItems::CartItemCreation

  attr_reader :cart_item

  def initialize cart, params
    self.cart_item = cart.cart_items.build(params)
  end

  def create!
    self.cart_item.save!
    return self.cart_item
  end

  private
  attr_writer :cart_item

end