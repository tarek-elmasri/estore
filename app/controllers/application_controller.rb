class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  include Responder::Base

  before_action :set_request


  def set_request
    Current.platform = request.headers["platform"]
    Current.token= request.headers['Authorization']
                          &.split("Bearer ")
                          &.first
  end

  private
  def authenticate_user
    begin
      return unauthorized unless Current.token
      decoder = JwtHandler::Decoder.new(Current.token)

      Current.user_id = decoder.payload.dig(:id)
      Current.rule = decoder.payload.dig(:rule)
    
    rescue JWT::ExpiredSignature
      return expired_token
    rescue JWT::DecodeError
      return invalid_token
    # rescue
    #   return unauthorized
      
    end
  end

  def load_authenticated_user
    # supposed to be called after authenticate user
    Current.user = User.find(Current.user_id)

    # suppoed no errors
    rescue
      return unauthorized
  end

end
