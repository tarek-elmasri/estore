class Interfaces::OrderItems::UpdateDeliveryStatus
  include StaffTracker::Recorder

  attr_reader :order_item

  def initialize order_item
    self.order_item = order_item
  end


  def update! status
    check_authorization
    check_order_is_fullfilled
    OrderItem.transaction do
      self.order_item.update!(delivery_status: status)
      Order::OrderUpdate.new(self.order_item.order)
                        .update_delivery_status!
    end

    record_action(
      :update,
      "order_item",
      self.order_item.id
    )

    return self.order_item
  end

  private
  attr_writer :order_item

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_order_item?
  end

  def check_order_is_fullfilled
    raise Errors::Unauthorized unless self.order_item.order.is_fullfilled?
  end
end