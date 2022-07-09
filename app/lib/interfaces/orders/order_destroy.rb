class Interfaces::Orders::OrderDestroy

  attr_reader :order

  def initialize order
    self.order=order
  end

  def destroy!
    raise Errors::Unauthorized if order.is_fullfilled?

    Order.transaction do
      release_order_quantities
      self.order.destroy!
    end

    return self.order
  end

  private
  attr_writer :order

  def release_order_quantities
    self.order.order_items.each do |oi|
      item = Item.find(oi.item_id)
      Item::ItemStocker.new(item).release_stock!(oi.quantity)
    end
  end

end