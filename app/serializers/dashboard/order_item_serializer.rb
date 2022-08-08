class Dashboard::OrderItemSerializer < ActiveModel::Serializer

  attributes :id, :total_price, :price , :delivery_status, 
              :quantity, :type_name, :item_id, :description,
              :created_at, :updated_at

  def price
    object.value
  end

  def total_price
    object.t_value
  end
end