class Dashboard::StaffActionSerializer < ActiveModel::Serializer

  attributes :id, :action, :model_id, :model

  has_one :user
end