class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_user, only: [:me,:logout]
  before_action :load_authenticated_user , only: [:me]

  def me
    respond({user: Current.user})
  end

  def login
    user = User.auth(login_params)

    if user
      create_user_session(user)
      return respond_with_user_data(user)
    else
      return un_processable()
    end
  end

  def signup
    user = User.new(signup_params)
    
    if user.save
      create_user_session(user)
      return respond_with_user_data(user)
    else
      un_processable(user.errors)
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
    user_session= Session.find_by(user_id: Current.user_id)&.destroy
    respond({message: :ok})
  end

  def forget_password
    user = User.find_by(email: params[:email])
    if user
      return blocked_user if user.blocked?
      # send email with params[:reset_link] with token=user.forget_password_token
      #set job to regenerate forget password token after 10 mins to de validate token
    end

    respond({message: ok})
  end

  def validate_forget_password_token
    user = User.find_by(forget_password_token: params[:token])
    if user
      respond({email: user.email})
    else
      return unauthorized
    end
  end

  def reset_password
    user = User.find_by(forget_password_token: params[:token])
    return unauthorized unless user

    user.password= params[:password]
    if user.save
      user.delete_current_session
      user.create_session
      user.reset_refresh_token
      user.regenerate_forget_password_token
      respond_with_user_data(user)
      
    else
      return un_processable(user.errors)
    end

    rescue => e
      un_processable({errors: e})
  
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

  def create_user_session user
    session[:session_id] = user.session.id if Current.web_platform? && user.active?
  end


  def refresh_through_web
    current_session = Session.find_by(id: session[:session_id], version: APP_VERSION)
    return unauthorized if current_session.blank?
    return respond_with_user_data(current_session.user)
  end

  def refresh_through_mobile
    begin
      decoder = JwtHandler::Decoder.new(params[:refresh_token])
      user= User.find_by(id: decoder.payload.dig(:id))
      return respond_with_user_data(user)

    rescue JWT::ExpiredSignature
      return expired_token
    rescue JWT::DecodeError
      return invalid_token
      
    end
  end

  def respond_with_user_data user
    return unauthorized if user.blank?
    return blocked_user if user.blocked?
    respond({tokens: user.tokens , user:user})
  end
end