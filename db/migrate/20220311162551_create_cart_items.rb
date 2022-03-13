class CreateCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_items, id: :uuid do |t|
      t.belongs_to :cart, null: false, foreign_key: true, type: :uuid
      t.belongs_to :item, null: false, foreign_key: true, type: :uuid
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
