class OrderItemSerializer < ActiveModel::Serializer

  attributes :total_price, :price , :delivery_status, :quantity, :type_name, :description

  def price
    object.value
  end

  def total_price
    object.t_value
  end
end