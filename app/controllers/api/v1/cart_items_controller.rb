class Api::V1::CartItemsController < ApplicationController
  before_action :authenticate_user
  before_action :set_cart
  before_action :set_cart_item, except: [:create]


  def create
    ci = @cart.cart_items.build(cart_item_params)
    ci.save!
    respond(ci)
  end

  def update
    @cart_item.update!(cart_item_params)
    respond(@cart_item)
  end

  def destroy
    @cart_item.destroy!
    respond_ok()
  end

  private

  def set_cart
    @cart= Current.user.cart
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find(params.requires(:id))
  end

  def cart_item_params
    params.require(:cart_item).permit(
      :item_id,
      :quantity
    )
  end
end