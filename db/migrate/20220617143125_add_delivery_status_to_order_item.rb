class AddDeliveryStatusToOrderItem < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :delivery_status, :string, null:false , default: "pending"
  end
end
