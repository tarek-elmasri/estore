class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_user, only: [:logout]

  def create
    Current.user = User.auth(login_params)
    create_session_cookies(Current.user)
    respond({tokens: Current.user.tokens})
  end

  def update
    if Current.web_platform?
      return refresh_through_web()
    else
      return refresh_through_mobile()
    end
  end

  def delete
    session['session_id'] = nil if Current.web_platform?
    Session.kill_by_user_id(Current.user.id)
    respond_ok()
  end

  private

  def login_params
    params.require(:user).permit(:phone_no , :password)
  end



  def refresh_through_web
    current_session = Session.find_by_id_and_version!(session[:session_id], APP_VERSION)
    respond({
      access_token: current_session.user.generate_access_token
      })
  end

  def refresh_through_mobile
    decoder = JwtHandler::Decoder.new(params[:refresh_token], :refresh_token)
    user= User.find(decoder.payload.dig(:id))

    respond({
      access_token: user.generate_access_token
      })
  end


end