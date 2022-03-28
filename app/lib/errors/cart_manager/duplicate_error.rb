class Errors::CartManager::DuplicateError < Errors::CustomError

  def initialize
    super(
      "errors.cart_items.duplicate",
      "CI102",
      "422"
    )
  end
end