class Api::V1::Dashboard::OrdersController < Api::V1::Dashboard::Base
  include Scopes::Dashboard::OrdersScopes

  before_action :authorize_show , only: [:index]

  apply_controller_scopes

  def index
    orders= apply_scopes(Order.fullfilled.include_order_items.page(1))

    respond({
      orders: serialize_resource(
                orders,
                each_serializer: Dashboard::OrderSerializer
              ),
      pagination_details: pagination_details(orders)
    })
  end



  def authorize_show
    raise Errors::Unauthorized unless Current.user.is_authorized_to_show_orders?
  end

end