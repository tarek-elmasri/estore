class Errors::CartManager::ZeroQuantityError < Errors::CustomError

  def initialize
    super(
      "errors.cart_items.invalid_quantity",
      "CI101",
      "422"
    )
  end
end