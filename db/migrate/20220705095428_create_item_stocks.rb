class CreateItemStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :item_stocks, id: :uuid do |t|
      t.integer :active, null:false , default: 0
      t.integer :pending, null:false , default: 0
      t.integer :sales, null:false , default: 0
      t.belongs_to :item, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
