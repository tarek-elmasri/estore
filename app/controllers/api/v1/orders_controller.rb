class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    orders= Current.user.orders.fullfilled
    respond({
      orders: serialize_resource(
        orders,
        each_serializer: OrderSerializer
      )
    })
  end

  # def create
  #   order = Order.new(cart: Current.user.get_full_cart)
  #   order.save!

  #   # TODO: Background job to destroy the order if not finished 
  #   respond(order)
  # end

  def create
    order = Order::OrderCreation.new(Current.user.get_full_cart, Current.user)
                                .create!
    respond(order)
  end
end