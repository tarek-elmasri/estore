module OrderHandler
  class Stocks

    attr_reader :order
    def initialize(order)
      raise StandardError.new('Order is not fullfilled.') unless order.is_fullfilled?
      self.order=order
    end

    def handle
      order.order_items.each do |oi|
        if oi.is_card?
          Card.attach_codes_to_order_item(oi)
          self.require_delivery = true
        end
        eleminate_stocks(oi)
      end

      # DeliveryManager.new(self.order).deliver_cards if self.require_delivery
    end

    private
    attr_writer :order
    attr_accessor :require_delivery
    def eleminate_stocks(oi)
      item=Item.find(oi.item_id)
      report(oi.order) unless item.has_stock?(oi.quantity)
      item.eleminate_quantity(oi.quantity)
    end

    def report(o)
      # reporting quantites miss count
      puts "Order Item of id #{o.id} \n ran out of stock"
    end

  end
end