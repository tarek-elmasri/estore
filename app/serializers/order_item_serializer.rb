class OrderItemSerializer < ActiveModel::Serializer

  attributes :t_value, :value , :delivery_status, :quantity

end