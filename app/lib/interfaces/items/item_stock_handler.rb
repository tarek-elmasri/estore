module Interfaces::Items::ItemStockHandler

  def update_item_stock!
    item_stock = ItemStock.where(item_id: self.item.id).first_or_initialize
    item_stock.with_lock do
      item_stock.has_limited_stock = self.item.has_limited_stock || false
      item_stock.active= self.item.stock || 0
      item_stock.notify_on_low_stock = self.item.notify_on_low_stock || false
      item_stock.low_stock = self.item.low_stock || 0
      item_stock.save!
    end
  end

end