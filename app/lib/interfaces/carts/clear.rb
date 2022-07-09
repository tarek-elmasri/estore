class Interfaces::Carts::Clear

  attr_reader :cart

  def initialize cart
    self.cart= cart
  end

  def clear!
    self.cart.cart_items.destroy_all
    return self.cart
  end

  private 
  attr_writer :cart

end