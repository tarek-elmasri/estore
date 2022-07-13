class Interfaces::OrderItems::CardsMailerUpdateDeliveryStatus

  attr_reader :order_items

  def initialize order_items
    self.order_items= order_items
  end

  def update_all status
    OrderItem.transaction do
      self.order_items.update_all(delivery_status: status)
      Order::OrderUpdate.new(self.order_items.first.order)
                        .update_delivery_status!
    end

    return self.order_items
  end

  private
  attr_writer :order_items
    
end