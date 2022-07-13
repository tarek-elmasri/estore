class Api::V1::Dashboard::OrderItemsController < Api::V1::Dashboard::Base
  before_action :set_order_item, only: [:update]

  def update
    updated_oi = OrderItem::UpdateDeliveryStatus.new(@order_item).update!(params.require(:delivery_status))
    respond(
      serialize_resource(
        updated_oi,
        serializer: Dashboard::OrderItemSerializer
      )
    )
  end

  private
  def set_order_item
    @order_item = OrderItem.include_order.find(params.require(:id))
  end
end