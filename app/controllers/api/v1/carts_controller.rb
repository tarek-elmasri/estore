class Api::V1::CartsController < ApplicationController
  before_action :authenticate_user

  def index
    respond(Current.user.cart, include: ['cart_items.item'])
  end
end