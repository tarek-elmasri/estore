class Api::V1::UsersController < ApplicationController 
  before_action :authenticate_user, except: [:create]

  def index
    user= User.load_with_cart_and_authorization(Current.user.id)
    respond(user, include: ['cart.cart_items.item', 'authorization'])
  end

  def update
    user = User::UserUpdate.new(Current.user.reload)
                            .update!(users_params.except(:password))
    respond(user)
    # Current.user.reload
    # Current.user.update!(users_params.except(:password))
    # respond(Current.user)
  end

  def create
    user= User::Authentication.register(users_params)
    create_session_cookies(user)
    respond({tokens: user.tokens})
    # Current.user = User.new(users_params)
    # Current.user.should_validate_password = true
    # Current.user.save!
    # create_session_cookies(Current.user)
    # respond({tokens: Current.user.tokens})
  end

  private
  def users_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :phone_no,
      :city,
      :email,
      :gender,
      :password
    )
  end


end
