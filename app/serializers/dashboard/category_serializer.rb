class Dashboard::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :primary_category_id
end