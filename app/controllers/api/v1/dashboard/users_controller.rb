class Api::V1::Dashboard::UsersController < Api::V1::Dashboard::Base

  before_action :set_user , only: [:update]
  before_action :authorize_show, only: [:index]

  def index
    users= User.all
    respond({users: users})
  end


  def update
    @user.update!(user_params)
    Current.user.staff_actions.create(action: :update, model: :user, model_id: @user.id)
    respond({user: @user})
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
      :rule
    )
  end

  def authorize_show
    raise Errors::Unauthorized unless Current.user.is_authorized_to_show_users?
  end

  def set_user
    @user= User.find(params[:id])
  end


end