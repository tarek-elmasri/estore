class Dashboard::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :pinned

  has_many :sub_categories, serializer: Dashboard::CategorySerializer
  has_one :primary_category, serializer: Dashboard::CategorySerializer
end