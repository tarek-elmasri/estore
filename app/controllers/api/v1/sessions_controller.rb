class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_user, only: [:logout]

  def login
    Current.user = User.auth(login_params)
    create_session_cookies(Current.user)
    # respond_with_user_data(Current.user)
    respond(user_data)
  end

  def register
    Current.user = User.new(signup_params)
    Current.user.should_validate_password = true
    Current.user.save!
    create_session_cookies(Current.user)
    # respond_with_user_data(Current.user)
    respond(user_data)
  end

  def refresh
    if Current.web_platform?
      return refresh_through_web()
    else
      return refresh_through_mobile()
    end
  end

  def logout
    session['session_id'] = nil if Current.web_platform?
    Session.kill_by_user_id(Current.user.id)
    respond_ok()
  end

  def forget_password
    User.request_forget_password_token_by_email(params[:email])
    respond_ok()
  end

  def validate_password_token
    user = User.find_by_password_token!(params[:token])
    respond({email: user.email})
  end

  def reset_password
    Current.user = User.find_by_password_token!(params[:token])
    Current.user.reset_password params[:password]
    create_session_cookies(Current.user)
    respond(user_data)
    # respond_with_user_data(Current.user)
    
  end

  private

  def signup_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :phone_no,
      :email,
      :password,
      :gender
    )
  end

  def user_data
    {tokens: Current.user.tokens, user: serialize_resource(Current.user)}
  end

  def login_params
    params.require(:user).permit(:phone_no , :password)
  end

  def create_session_cookies user
    session[:session_id] = user.session.id if Current.web_platform?
  end


  def refresh_through_web
    current_session = Session.find_by_id_and_version!(session[:session_id], APP_VERSION)
    # respond_with_access_token(current_session.user)
    respond({
      access_token: current_session.user.generate_access_token,
      user: serialize_resource(current_session.user)
      })
  end

  def refresh_through_mobile
    decoder = JwtHandler::Decoder.new(params[:refresh_token], :refresh_token)
    user= User.find(decoder.payload.dig(:id))
    # respond_with_access_token(user)
    respond({
      access_token: user.generate_access_token,
      user: serialize_resource(user)
      })
  end


end