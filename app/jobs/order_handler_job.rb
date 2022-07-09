class OrderHandlerJob < ApplicationJob
  queue_as :critical

  def perform(order_id)
    order=Order.include_user
                .include_order_items
                .find(order_id)

    return unless order.is_fullfilled?
    # order.transaction do
    #   OrderHandler::Stocks.new(order).handle 
    # end
    Order::OrderConfirm.new(order).confirm!            
  end
end
