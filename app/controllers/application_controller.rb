class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  include Responder::Base

  before_action :set_request


  def set_request
    Current.request = request
  end

  private
  def authenticate_user
    token = request.headers["Authorization"]
    data = JwtHandler::Decoder.new(token)

    Current.user_id = data.payload.dig(:id)
    Current.rule = data.payload.dig(:rule)
    
  rescue JWT::ExpiredSignature
    return expired_token
  rescue JWT::DecodeError
    return invalid_token
  rescue
    return unauthorized
  end
end
