class User < ApplicationRecord
  include JwtHandler::AuthTokens

  has_secure_password

  has_refresh_token_fields :first_name
  has_access_token_fields :first_name

  has_one :cart
end
