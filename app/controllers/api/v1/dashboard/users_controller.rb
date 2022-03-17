class Api::V1::Dashboard::UsersController < Api::V1::Dashboard::Base

  before_action :authorize_update , only: [:update]

  def index
    if Current.user.is_authorized_to_show_users?
      users= User.all
      respond({users: users})
    else
      respond_forbidden
    end
  end


  def update
    if @user.update(user_params)
      Current.user.staff_actions.create(type: :update, model: :user, model_id: @user.id)
      respond({user: @user})
    else
      respond_unprocessable(@user.errors)
    end
  end


  private
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :phone_no,
      :email,
      :gender,
      :dob,
      :city,
      :status,
      :rule,
    )
  end

  def authorize_update
    return respond_forbidden unless Current.user.is_authorized_to_update_users?
    
    @user= User.find_by_id(params[:id])
    return respond_not_found unless @user

  end


end