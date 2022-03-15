class User < ApplicationRecord
  include JwtHandler::AuthTokens

  has_secure_password

  has_refresh_token_fields :first_name
  has_access_token_fields :first_name

  has_one :cart
  has_one :session

  after_create: :create_session


  private
  def create_session
    session.create(version: :APP_VERSION)
  end

end
