class OrderSerializer < ActiveModel::Serializer

  attributes :id, :total_payment, :total_price , :delivery_status

  has_many :order_items, serializer: OrderItemSerializer
  
  def total_price
    object.t_value
  end

  def total_payment
    object.t_payment
  end
end