class AddDeliveryStatusToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :delivery_status, :string, null:false , default: "pending"
  end
end
