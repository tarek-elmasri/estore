class Dashboard::OrderItemSerializer < ActiveModel::Serializer

  attributes :t_value, :value , :dellivery_status, :quantity

end