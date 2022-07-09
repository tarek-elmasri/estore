class Interfaces::Cards::AttachToOrderItem

  attr_reader :order_item

  def initialize order_item
    self.order_item = order_item
  end

  def attach!
    check_order_is_fullfilled

    raise Errors::Unauthorized unless self.order_item.is_card?

    Card.transaction do
      cards=Card.available
                .where(item_id: self.order_item.item_id)
                .order(created_at: :asc)
                .limit(self.order_item.quantity)
                .lock!
      
      # have to get any attribute from cards to perform the lock
      raise StandardError.new('no cards available match required quantity') if cards.length < self.order_item.quantity
    
      cards.update_all(
        order_item_id: self.order_item.id,
        active: false
      )

      # eleminating stock from pending to sales
      item= Item.find(self.order_item.item_id)
      Item::ItemStocker.new(item).sell_stock!(self.order_item.quantity)
    end
    
  
  end


  private

  attr_writer :order_item

  def check_order_is_fullfilled
    raise Errors::Unauthorized unless self.order_item.order.is_fullfilled?
  end
end