class Dashboard::OrderItemSerializer < ActiveModel::Serializer

  attributes :id, :t_value, :value , :delivery_status, :quantity

end