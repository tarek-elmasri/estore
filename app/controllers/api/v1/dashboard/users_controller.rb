class Api::V1::Dashboard::UsersController < Api::V1::Dashboard::Base
  include Scopes::Dashboard::UsersScopes
  
  before_action :set_user , only: [:update]
  before_action :authorize_show, only: [:index]

  apply_controller_scopes only: [:index]

  def index
    users = apply_scopes(User.include_authorization.page(1))
    respond({
      users: serialize_resource(
                users, 
                each_serializer: Dashboard::UserSerializer
              ),
      pagination_details: pagination_details(users)
    })
  end


  def update
    updated_user= User::UserUpdate.new(@user).update!(user_params)
    respond(
      serialize_resource(
        updated_user,
        serializer: Dashboard::UserSerializer
      ).to_json
    )
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
    @user= User.find(params.require(:id))
  end


end