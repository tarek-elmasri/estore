class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.float :t_value, null: false
      t.float :t_vat, null:false
      t.string :status, null:false , default: "established"
      t.string :payment_intent
      t.float :t_payment, null:false

      t.timestamps
    end
  end
end
