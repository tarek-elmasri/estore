class Api::V1::CartsController < ApplicationController
  before_action :authenticate_user

  def index
    respond(Current.user.cart, include: ['cart_items.item'])
  end

  def sync
    updated_cart = Cart::Sync.new(Current.user.cart)
                              .sync(sync_params)
    respond(updated_cart, include: ['cart_items.item'])
  end

  private
  def sync_params
    params.permit(cart_items: [:item_id, :quantity]).require(:cart_items)
  end
end