class Api::V1::Dashboard::UsersController < Api::V1::Dashboard::Base

  before_action :set_user , only: [:update]
  before_action :authorize_show, only: [:index]

  has_scope :paginate, using: %i[page per], type: :hash, allow_blank: true, only: [:index]
  has_scope :only_blocked, as: :blocked, type: :boolean, only: [:index]
  has_scope :only_staff, as: :staff, type: :boolean, only: [:index]
  has_scope :by_phone_no, as: :phone_no, only: [:index]
  has_scope :by_email, as: :email, only: [:index]
  has_scope :by_city, as: :city, only: [:index]
  has_scope :by_gender, only: [:index]
  has_scope :of_ids, as: :id

  def index
    users = apply_scopes(User.page(1))
    respond({
      users: serialize_resource(
        users, 
        each_serializer: Dashboard::UserSerializer
      ),
      pagination_details: pagination_details(users)
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