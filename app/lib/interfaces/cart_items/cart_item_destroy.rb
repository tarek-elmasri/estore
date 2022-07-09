class Interfaces::CartItems::CartItemDestroy

  attr_reader :cart_item

  def initialize cart_item
    self.cart_item = cart_item
  end

  def destroy!
    self.cart_item.destroy!
  end

  private
  attr_writer :cart_item

end