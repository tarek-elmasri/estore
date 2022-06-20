class AddTypeNameToOrderItem < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :type_name, :string, null:false
  end
end
