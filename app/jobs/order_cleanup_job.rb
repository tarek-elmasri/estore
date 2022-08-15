class OrderCleanupJob < ApplicationJob
  queue_as :low

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order
    return if order.is_fullfilled?
    
    if order_should_destroyed?(order)
      Order::OrderDestroy.new(order).destroy!
    else
      # schedule another job
      OrderCleanupJob.set(wait: calculate_next_cleanup_job_wait_minutes(order)).perform_later(order_id)
    end
  end

  private
  def order_should_destroyed?(order)
    # last touched over DEFAULT DESTROY TIME
    DateTime.now.to_i - order.updated_at.to_i >= Order::DEFAULT_DESTROY_TIME.to_i
  end

  def calculate_next_cleanup_job_wait_minutes(order)
    # add DEFAULT DESTROY TIME to last updated
    
    estimated= Order::DEFAULT_DESTROY_TIME.to_i - (DateTime.now.to_i - order.updated_at.to_i)
    
    estimated.positive? ? estimated : 1.minute
  end
end
