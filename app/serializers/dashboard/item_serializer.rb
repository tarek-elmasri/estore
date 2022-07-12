class Dashboard::ItemSerializer < ActiveModel::Serializer

  attributes :id, :name , :type_name, :price, :active_stock, :pending_stock , :sold_quantity, :cost

  has_many :item_categories, serializer: Dashboard::ItemCategorySerializer
end