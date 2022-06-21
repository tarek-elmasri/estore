class CartItemSerializer < ActiveModel::Serializer
  attributes  :id, :quantity

  belongs_to :item, serializer: ItemSerializer
end
