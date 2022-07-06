class AddAttributesToItemStock < ActiveRecord::Migration[6.1]
  def change
    add_column :item_stocks, :low_stock, :integer, default: 0
    add_column :item_stocks, :notify_on_low_stock, :boolean, default: false
  end
end
