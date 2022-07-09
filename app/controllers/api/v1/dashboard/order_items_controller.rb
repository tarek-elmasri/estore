class Api::V1::Dashboard::OrderItemsController < Api::V1::Dashboard::Base
  before_action :set_order_item, only: [:update]

  def update
    updated_oi = OrderItem::UpdateDeliveryStatus.new(@order_item).update!(params.require(:delivery_status))
    # @order_item.update!(delivery_status: params.require(:delivery_status))
    respond(updated_oi)
  end

  private
  def set_order_item
    # raise Errors::Unauthorized unless Current.user.is_authorized_to_update_order_item?
    @order_item = OrderItem.include_order.find(params.require(:id))
  end
end