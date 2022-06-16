class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user
  before_action :set_order

  def create
    
  end


  def update
    
  end

  private
  def set_order
    @order= Current.user.orders.find(params[:order_id])
  end


end