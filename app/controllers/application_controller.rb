class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  include Responder::Json
  include Errors::ErrorHandler::Base

  # before_action :raise_error
  before_action :set_request

  # def raise_error
    # raise Errors::BlockedUser
  # end
  

  def set_request
    Current.platform = request.headers["platform"]
    Current.token= request.headers['Authorization']
                          &.split("Bearer ")
                          &.last
  end

  protected
  def authenticate_user
      decoder = JwtHandler::Decoder.new(Current.token, :access_token)
      id = decoder.payload.dig(:id)
      rule = decoder.payload.dig(:rule)
      Current.user = User.new(id: id, rule: rule)
      # Current.user_id = decoder.payload.dig(:id)
  end

  def serialize_resource resource
    ActiveModelSerializers::SerializableResource.new(resource)
  end

  # def load_authenticated_user
  #   # supposed to be called after authenticate user
  #   Current.user.reload

  # end

end
