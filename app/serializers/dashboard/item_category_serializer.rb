class Dashboard::ItemCategorySerializer < ActiveModel::Serializer

  attributes :id

  has_one :category, serializer: Dashboard::CategorySerializer

end