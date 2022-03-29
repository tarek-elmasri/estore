class Api::V1::UsersController < ApplicationController 
  before_action :authenticate_user
  # before_action :load_authenticated_user

  def index
    respond({user: Current.user.reload})
  end

  def update
    Current.user.reload
    Current.user.update!(users_params)
    respond(user: Current.user)
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
