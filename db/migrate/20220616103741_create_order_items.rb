class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items, id: :uuid do |t|
      t.belongs_to :order, null: false, foreign_key: true, type: :uuid
      t.integer :quantity, null:false
      t.float :value, null:false
      t.float :t_value, null:false
      t.string :description, null:false
      t.uuid :item_id, null:false

      t.timestamps
    end
  end
end
