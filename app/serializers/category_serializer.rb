class CategorySerializer < ActiveModel::Serializer

  attributes :id, :name

  has_many :sub_categories, serializer: CategorySerializer
  has_many :items

end