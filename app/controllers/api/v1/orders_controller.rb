class Api::v1::OrdersController < ApplicationController
  before_action :authenticate_user

  def create
    order = Order.new(cart: Current.user.get_full_cart)
    order.save!

    # TODO: Background job to destroy the order if not finished 
    respond(order)
  end
end