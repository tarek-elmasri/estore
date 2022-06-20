class Errors::ItemHasCardsError < Errors::CustomError

  def initialize
    super(
      "errors.authorization.item_have_cards",
      "UP498",
      "422"
    )
  end
end