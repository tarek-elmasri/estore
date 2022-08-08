class Dashboard::StaffActionSerializer < ActiveModel::Serializer

  attributes :id, :action, :model_id, :model, :created_at

  has_one :user
end