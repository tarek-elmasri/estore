class Errors::CartManager::MultipleQuantityError < Errors::CustomError

  def initialize
    super(
      "errors.cart_items.multiple_quantity",
      "CI104",
      "422"
    )
  end
end