class Dashboard::NotificationSerializer < ActiveModel::Serializer
  attributes :id , :seen, :message , :model_name, :model_id, :created_at


end