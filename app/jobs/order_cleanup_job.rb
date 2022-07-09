class OrderCleanupJob < ApplicationJob
  queue_as :low

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order
    return if order.is_fullfilled?
    
    Order::OrderDestroy.new(order).destroy!
    # order.destroy!
  end
end
