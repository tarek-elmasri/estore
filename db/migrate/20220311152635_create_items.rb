class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items, id: :uuid do |t|
      t.string :type_name, null:false
      t.string :name, null:false
      t.float :price, null:false
      t.boolean :has_limited_stock,null: false, default: true
      t.integer :stock
      t.integer :low_stock
      t.boolean :notify_on_low_stock, default:false
      t.boolean :visible, default:false
      t.string :code
      t.float :cost
      t.float :discount_price
      t.boolean :has_discount, default:false
      t.datetime :discount_end_date
      t.datetime :discount_start_date
      t.boolean :limited_quantity_per_customer, default: false
      t.integer :max_quantity_per_customer
      t.boolean :allow_multi_quantity, default:false
      t.boolean :allow_duplicate, default:false
      t.string :title
      t.string :sub_title
      t.string :hint

      t.timestamps
    end
  end
end
