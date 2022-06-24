class OrderCleanupJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return if order.is_fullfilled?
    
    order.destroy!
  end
end
