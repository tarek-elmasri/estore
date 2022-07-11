class Api::V1::Dashboard::UsersController < Api::V1::Dashboard::Base

  before_action :set_user , only: [:update]
  before_action :authorize_show, only: [:index]

  def index
    users= User.all
    respond({
      users: serialize_resource(users, each_serializer: Dashboard::UserSerializer)
    })
  end


  def update
    #@user.update!(user_params)
    updated_user= User::UserUpdate.new(@user).update!(user_params)
    respond(updated_user)
  end


  private
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :phone_no,
      :email,
      :gender,
      :status,
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
    @user= User.find(params.require(:id))
  end


end