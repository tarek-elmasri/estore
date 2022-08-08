class CategorySerializer < ActiveModel::Serializer

  attributes :id, :name, :pinned

  has_many :sub_categories, serializer: CategorySerializer
  has_one :primary_category, serializer: CategorySerializer
end