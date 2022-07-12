class CategorySerializer < ActiveModel::Serializer

  attributes :id, :name

  #has_many :items, serializer: ItemSerializer
  has_many :sub_categories
end