class Api::V1::Dashboard::OrdersController < Api::V1::Dahsboard::Base

  before_action :authorize_show , only: [:index]

  
  def index
    orders=Order.fullfilled.order(created_at: :desc)
    respond({orders: serialize_resource(
      orders,
      each_serializer: Dashboard::OrderSerializer
    )})
  end

 

  def authorize_show
    raise Errors::Unauthorized unless Current.user.is_authorized_to_show_orders?
  end

end