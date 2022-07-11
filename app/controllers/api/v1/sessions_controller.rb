class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_user, only: [:delete]

  def create
    user= User::Authentication.login(login_params)
    create_session_cookies(user)
    # Current.user = User.auth(login_params)
    # create_session_cookies(Current.user)
    respond({tokens: user.tokens})
  end

  def update
    if Current.web_platform?
      return refresh_through_web()
    else
      return refresh_through_mobile()
    end
  end

  def delete
    #session['id'] = nil if Current.web_platform?
    session[:refresh_token] = nil if Current.web_platform?
    #User::Authentication.logout(Current.user.id)
    #Session.kill_by_user_id(Current.user.id)
    respond_ok()
  end

  private

  def login_params
    params.require(:user).permit(:phone_no , :password)
  end



  def refresh_through_web
    #current_session = Session.find_by_id_and_version!(session[:id], APP_VERSION)
    user= User.find_by_refresh_token!(session[:refresh_token])
    respond({
      access_token: user.generate_access_token
      })
  end

  def refresh_through_mobile
    decoder = JwtHandler::Decoder.new(params.require(:refresh_token), :refresh_token)
    user= User.find(decoder.payload.dig(:id))

    respond({
      access_token: user.generate_access_token
      })
  end


end