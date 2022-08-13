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
  end

  def create
    user= User::Authentication.register(users_params)
    create_session_cookies(user)
    respond({tokens: user.tokens})
  end

  def create_avatar
    upload_data = User::UserUpdate.new(Current.user)
                                  .data_for_avatar_upload(
                                    filename: params.require(:filename),
                                    checksum: params.require(:checksum),
                                    byte_size: params.require(:byte_size),
                                    content_type: params.require(:content_type)
                                  )
    respond({data: upload_data})
  end

  def update_avatar
    User::UserUpdate.new(Current.user.reload)
                    .update_avatar!(params.require(:signed_id))
    respond(Current.user.reload)
  end

  def destroy_avatar
    User::UserUpdate.new(Current.user.reload)
                    .destroy_avatar!()
    respond_ok()
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
