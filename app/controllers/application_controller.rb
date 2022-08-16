class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  include Responder::Json
  include Errors::ErrorHandler::Base

  before_action :set_locale
  before_action :force_json
  before_action :set_request

  def set_request
    broweser = Browser.new(request.headers['user-agent'])
    Current.platform = browser.device.mobile? ? 'mobile' : 'web'
    Current.token= request.headers['Authorization']
                          &.split("Bearer ")
                          &.last

  end

  def unknown_route
    respond_not_acceptable("Invalid route. Please check github page for further information. https://github.com/tarek-elmasri/estore")
  end

  protected
  
  def create_session_cookies user
    session[:refresh_token] = user.refresh_token if Current.web_platform?
  end

  def authenticate_user
      decoder = JwtHandler::Decoder.new(Current.token, :access_token)
      id = decoder.payload.dig(:id)
      rule = decoder.payload.dig(:rule)
      Current.user = User.new(id: id, rule: rule)
  end

  def serialize_resource(resource, options={})
    ActiveModelSerializers::SerializableResource.new(resource, options)
  end

  def pagination_details(collection)
    collection = collection.without_count
    result = {}
    result[:current_page] = collection.current_page
    result[:limit_per_page] = collection.limit_value
    result[:next_page] = collection.next_page
    result[:prev_page]= collection.prev_page
    result[:has_next] = !!collection.next_page 
    return result
    rescue
      nil
  end

  def force_json
    unless request.headers['Content-Type'] == 'application/json' || request.body.read.blank?
      respond_not_acceptable("Content-Type must be application/json")
    end
  end

  def set_locale
    allowed_locales= ['en','ar']
    I18n.locale = if allowed_locales.include?(params[:locale])
      params[:locale]
    else
      'en'
    end
  end
end
