class OrderHandlerJob < ApplicationJob
  queue_as :critical

  def perform(order_id)
    order=Order.find(order_id)
    OrderHandler::Stocks.new(order).handle 
  end
end
