class Errors::CartManager::StockError < Errors::CustomError

  def initialize
    super(
      "errors.cart_items.no_stock",
      "CI103",
      "422"
    )
  end
end