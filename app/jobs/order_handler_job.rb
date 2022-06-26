class OrderHandlerJob < ApplicationJob
  queue_as :critical

  def perform(order_id)
    order=Order.include_user
                .include_order_items
                .find(order_id)
    order.transaction do
      OrderHandler::Stocks.new(order).handle 
    end            
  end
end
