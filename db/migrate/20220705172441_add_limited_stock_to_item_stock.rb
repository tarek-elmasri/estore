class AddLimitedStockToItemStock < ActiveRecord::Migration[6.1]
  def change
    add_column :item_stocks, :has_limited_stock, :boolean, default: false
  end
end
