class Dashboard::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :primary_category_id

  has_many :sub_categories, serializer: Dashboard::CategorySerializer
end