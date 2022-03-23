class Api::V1::CartItemsController < ApplicationController
  before_action :authenticate_user
  before_action :load_authenticated_user
  before_action :set_cart_manager

rescue_from CartManager::Errors::ItemNotFound,CartManager::Errors::CartItemNotFound do
  respond_not_found
end

rescue_from CartManager::Errors::InvalidZeroQuantity,CartManager::Errors::MultipleQuantityNotAllowed do
  respond_unprocessable({message: I18n.t('errors.cart_items.invalid_quantity')}, 'CI101')
end

rescue_from CartManager::Errors::DuplicateNotAllowed do
  respond_unprocessable({message: I18n.t('errors.cart_items.duplicate')}, 'CI102')
end

rescue_from CartManager::Errors::NoStock do
  respond_unprocessable({message: I18n.t('errors.cart_items.no_stock')}, 'CI103')
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