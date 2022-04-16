class Api::V1::CartItemsController < ApplicationController
  before_action :authenticate_user
  before_action :set_cart, except: [:index]


  def index
    cart=Current.user.get_cart
    respond(cart, include: 'cart_items.item')
  end

  def create
    item= Item.visible.find(params[:item_id])
    ci= @cart.add_item(item, params[:quantity])
    respond(ci)
  end

  def update
    ci = @cart.cart_items.includes(:item).find(params[:id])
    cart_item = @cart.update_quantity(ci, params[:quantity])
    respond(cart_item)
  end

  def destroy
    ci = @cart.cart_items.find(params[:id])
    cart_item = @cart.remove_item(ci)
    respond(cart_item)
  end

  def sync
    new_cart=@cart.sync(sync_cart_items_params)
    respond(new_cart)
  end

  private

  def set_cart
    @cart= Current.user.cart
  end

  def sync_cart_items_params
    params.permit(cart_items: [:item_id, :quantity])[:cart_items]
  end
end