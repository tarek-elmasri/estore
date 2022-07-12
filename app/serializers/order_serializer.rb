class OrderSerializer < ActiveModel::Serializer

  attributes :id, :t_payment, :t_value , :t_vat, :delivery_status

  has_many :order_items, serializer: OrderItemSerializer

end