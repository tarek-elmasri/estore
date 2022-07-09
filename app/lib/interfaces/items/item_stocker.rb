class Interfaces::Items::ItemStocker 

  attr_reader :item

  def initialize item
    self.item = item
  end

  def reserve_stock! amount
    self.item.item_stock.move_to_pending!(amount)
  end

  def sell_stock! amount
    self.item.item_stock.sell! amount
  end

  def release_stock! amount
    self.item.item_stock.release_from_pending! amount
  end

  def add_to_stock! amount
    self.item.item_stock.add_to_stock! amount
  end

  def remove_stock! amount
    self.item.item_stock.remove_from_stock! amount
  end

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

  private 
  attr_writer :item

end