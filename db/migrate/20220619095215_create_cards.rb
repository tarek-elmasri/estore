class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards, id: :uuid do |t|
      t.string :code, null:false
      t.belongs_to :order_item, null: true, foreign_key: true, type: :uuid
      t.belongs_to :item, null: false, foreign_key: true, type: :uuid
      t.boolean :active, null:false, default: true

      t.timestamps
    end
  end
end
