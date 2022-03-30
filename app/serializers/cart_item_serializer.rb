class CartItemSerializer < ActiveModel::Serializer
  attributes :id , :item_id, :quantity
end
