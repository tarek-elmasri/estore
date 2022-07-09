class Interfaces::Orders::OrderConfirm

  attr_reader :order

  def initialize order
    self.order= order
  end

  def confirm!
    require_delivery = false
    
    Order.transaction do
      order.order_items.each do |oi|
        if oi.is_card?
          Card::AttachToOrderItem.new(oi).attach!
          require_delivery = true
        else
          item= Item.find(oi.item_id)
          Item::ItemStocker.new(item).sell_stock!(oi.quantity)
        end
      end
    end

    CardsMailer.deliver_cards(self.order.id).deliver_later if require_delivery
  end


  private
  attr_writer :order

end