class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items, id: :uuid do |t|
      t.string :type, null:false
      t.string :name, null:false
      t.float :price, null:false
      t.boolean :has_limited_stock, null:false
      t.integer :stock
      t.integer :low_stock
      t.boolean :notify_on_low_stock, default:false
      t.boolean :visible, default:true
      t.belongs_to :category, null: false, foreign_key: true, type: :uuid
      t.string :code
      t.float :cost
      t.float :discount_price
      t.boolean :has_discount, default:false
      t.datetime :discount_end_date
      t.datetime :discount_start_date
      t.integer :max_quantity_per_customer
      t.boolean :allow_multi_quantity, default:true
      t.boolean :allow_duplicate, default:true
      t.string :title
      t.string :sub_title
      t.string :hint

      t.timestamps
    end
  end
end