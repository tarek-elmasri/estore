class CartItemSerializer < ActiveModel::Serializer
  attributes  :quantity

  belongs_to :item, serializer: ItemSerializer
end
