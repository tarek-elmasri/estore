class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  
  before_action :set_request

  def set_request
    Current.request = request
  end

  def hello
    render json: {hello: "hello"}
  end

  private
  def authenticate_user
    token = request.headers["Authorization"]
    authenticated = JwtHandler::Decoder.new(token).valid?
  end
end
