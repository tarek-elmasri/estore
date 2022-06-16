class CartSerializer < ActiveModel::Serializer

  has_many :cart_items, serializer: CartItemSerializer

end