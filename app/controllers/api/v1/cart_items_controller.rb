class Api::V1::CartItemsController < ApplicationController
  before_action :authenticate_user
  before_action :set_cart
  before_action :set_cart_item, except: [:create]


  def create
    cart_item = CartItem::CartItemCreation.new(@cart, cart_item_params).create!
    respond(cart_item)
  end

  def update
    updated_cart_item = CartItem::CartItemUpdate.new(@cart_item).update!(cart_item_params)
    respond(updated_cart_item)
  end

  def destroy
    CartItem::CartItemDestroy.new(@cart_item).destroy!
    respond_ok()
  end

  private

  def set_cart
    @cart= Current.user.cart
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find(params.require(:id))
  end

  def cart_item_params
    params.require(:cart_item).permit(
      :item_id,
      :quantity
    )
  end
end