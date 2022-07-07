class Interfaces::Orders::OrderUpdate 

  attr_reader :order

  def initialize order
    self.order = order
  end

  def update_delivery_status!
    if order.order_items.all? {|oi| oi.is_delivered?}
      order.delivery_status = 'delivered'
    elsif order.order_items.all? {|oi| oi.is_pending?}
      order.delivery_status = 'pending'
    else
      order.delivery_status = 'partial_delivery'
    end
    
    order.save!
  end

  def update_payment_status! intent_id, status
    self.order.update!(
      payment_intent: intent_id,
      status: status 
    )

    if (self.order.status_previously_changed? && self.order.status == 'succeeded')
      OrderHandlerJob.perform_later(self.order.id)
      InvoicesMailer.send_invoice(self.order.id).deliver_later
    end

    return self.order
  end

  private
  attr_writer :order

end