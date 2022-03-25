class Api::V1::SessionsController < ApplicationController

  def login
    user = User.auth(login_params)
    create_session_cookies(user)
    respond_with_user_data(user)
  end

  def register
    user = User.new(signup_params)
    user.save!
    create_session_cookies(user)
    respond_with_user_data(user)
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
    user.kill_current_session
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
    user = User.find_by_password_token!(params[:token])
    user.reset_password params[:password]
    create_session_cookies(user)
    respond_with_user_data(user)
    
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
    session[:session_id] = user.session.id if Current.web_platform?
  end


  def refresh_through_web
    current_session = Session.find_by_id_and_version!(session[:session_id], APP_VERSION)
    respond_with_access_token(current_session.user)
  end

  def refresh_through_mobile
    decoder = JwtHandler::Decoder.new(params[:refresh_token], :refresh_token)
    user= User.find(decoder.payload.dig(:id))
    respond_with_access_token(user)
  end


end