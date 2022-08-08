class Dashboard::OrderSerializer < ActiveModel::Serializer

  attributes :id, :total_payment, :total_value, :delivery_status, :status, :stripe_payment_id, :created_at, :updated_at

  has_many :order_items, serializer: Dashboard::OrderItemSerializer

  def total_price
    object.t_value
  end

  def total_payment
    object.t_payment
  end

  def stripe_payment_id
    object.payment_intent
  end
end