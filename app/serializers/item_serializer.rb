class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name , :type_name, :price, :active_stock, :pending_stock , :sold_quantity



end