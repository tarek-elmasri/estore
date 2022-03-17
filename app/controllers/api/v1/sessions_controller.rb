class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_user, only: [:me,:logout]
  before_action :load_authenticated_user , only: [:me]

  def me
    respond({user: Current.user})
  end

  def login
    user = User.auth(login_params)

    if user
      create_session_cookies(user)
      return respond_with_user_data(user)
    else
      return respond_invalid_credentials()
    end
  end

  def register
    user = User.new(signup_params)
    
    if user.save
      create_session_cookies(user)
      return respond_with_user_data(user)
    else
      respond_unprocessable(user.errors)
    end

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
    Session.kill_by_user_id Current.user_id
    respond_ok()
  end

  def forget_password
    user = User.find_by_email(params[:email])
    if user
      return respond_blocked_user() if user.blocked?
      # send email with params[:reset_link] with token=user.forget_password_token
      #set job to regenerate forget password token after 10 mins to de validate token
    end

    respond_ok()
  end

  def validate_password_token
    user = User.find_by_password_token(params[:token])
    if user
      respond({email: user.email})
    else
      return respond_invalid_password_token()
    end
  end

  def reset_password
    user = User.find_by_password_token(params[:token])
    return respond_invalid_password_token() unless user

    user.password= params[:password]
    if user.save
      user.kill_current_session
      user.create_session
      user.reset_refresh_token
      user.regenerate_forget_password_token
      # TODO: send email successsfull password change
      create_session_cookies(user)
      respond_with_user_data(user)
    else
      return respond_unprocessable(user.errors)
    end

    rescue => e
      respond_unprocessable(e)
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

  def login_params
    params.permit(:phone_no , :password)
  end

  def create_session_cookies user
    session[:session_id] = user.session.id if Current.web_platform? && user.active?
  end


  def refresh_through_web
    current_session = Session.find_by_id_and_version(session[:session_id], APP_VERSION)
    return respond_unauthorized if current_session.blank?
    return respond_with_access_token(current_session.user)
  end

  def refresh_through_mobile
    begin
      decoder = JwtHandler::Decoder.new(params[:refresh_token], :refresh_token)
      user= User.find_by_id(decoder.payload.dig(:id))
      return respond_with_access_token(user)

    rescue JWT::ExpiredSignature
      return respond_expired_token
    rescue JWT::DecodeError
      return respond_invalid_token
      
    end
  end


end