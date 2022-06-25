class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name , :type_name, :price, :stock
end