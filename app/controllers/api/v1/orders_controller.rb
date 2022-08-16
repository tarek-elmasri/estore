class Api::V1::OrdersController < ApplicationController
  include Scopes::OrdersScopes

  before_action :authenticate_user

  apply_controller_scopes only: [:index]
  
  def index
    orders= apply_scopes(Current.user.orders.fullfilled.include_order_items)
    
    respond({
      orders: serialize_resource(orders),
      pagination_details: pagination_details(orders)
    })
  end

  def create
    order = Order::OrderCreation.new(Current.user.get_full_cart)
                                .create!
    respond(order)
  end

  def destroy
    order = Current.user.orders.not_fullfilled.find_by(id: params.require(:id))
    if order
      Order::OrderDestroy.new(order)
                          .destroy!
    end
    respond_ok
  end
end