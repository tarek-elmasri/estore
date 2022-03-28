class Api::V1::CartItemsController < ApplicationController
  before_action :authenticate_user
  # before_action :load_authenticated_user
  before_action :set_cart_manager


  def index
    respond({cart_items: Current.user.cart.cart_items})
  end

  def create
    ci = @manager.add_item(CartItem.new(cart_items_params))
    respond({cart_item: ci})
  end

  def update
    ci = @manager.update_quantity(params[:id], params[:quantity])
    respond({cart_item: ci})
  end

  def destroy
    ci = @manager.remove_item(params[:id])
    respond({cart_item: ci})
  end

  private

  def cart_items_params
    params.require(:cart_item).permit(:item_id, :quantity)
  end

  def set_cart_manager
    @manager=CartManager::Cart.new(Current.user)
  end

end