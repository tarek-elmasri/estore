class OrderHandlerJob < ApplicationJob
  queue_as :critical

  def perform(order_id)
    order=Order.include_user
                .include_order_items
                .include_order_cards
                .find(order_id)
                
    OrderHandler::Stocks.new(order).handle 
  end
end
