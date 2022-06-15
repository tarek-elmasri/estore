class CartSerializer < ActiveModel::Serializer

  attributes :cart_errors
  has_many :cart_items, serializer: CartItemSerializer

  def cart_errors
    object.valid_for_checkout? ?
          nil : object.checkout_errors
  end
end