class ItemCategorySerializer < ActiveModel::Serializer
  attributes :id

  has_one :category , serializer: CategorySerializer
end