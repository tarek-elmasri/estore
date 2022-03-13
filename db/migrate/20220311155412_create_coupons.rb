class CreateCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :coupons, id: :uuid do |t|
      t.string :code
      t.integer :amount
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
