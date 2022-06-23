class Api::V1::Dashboard::OrderItemsController < Api::V1::Dashboard::Base
  before_action :authorize_update, only: [:update]

  def update
    @order_item.update!(delivery_status: params.require(:delivery_status))
    respond(@order_item)
  end

  private
  def authorize_update
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_order_item?
    @order_item = OrderItem.find(params.require(:id))
    raise Errors::Unauthorized unless @order_item.is_item? || @order_item.order.is_fullfilled?
  end
end