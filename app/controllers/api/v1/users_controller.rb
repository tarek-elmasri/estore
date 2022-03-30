class Api::V1::UsersController < ApplicationController 
  before_action :authenticate_user
  # before_action :load_authenticated_user

  def index
    user= User.includes(cart: [cart_items: :item]).includes(:authorization).find(Current.user.id)
    respond(user)
  end

  def update
    Current.user.reload
    Current.user.update!(users_params)
    respond(Current.user)
  end

  private
  def users_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :phone_no,
      :email,
      :gender,
    )
  end

  


end
