class OrderCleanupJob < ApplicationJob
  queue_as :low

  def perform(order_id)
    order = Order.find(order_id)
    return if order.is_fullfilled?
    
    order.destroy!
  end
end
