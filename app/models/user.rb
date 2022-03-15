class User < ApplicationRecord
  include JwtHandler::AuthTokens

  has_secure_password

  has_refresh_token_fields :first_name
  has_access_token_fields :first_name

  has_one :cart
  has_one :session


  after_create :create_session

  def self.auth credentials
    user = find_by(phone_no: credentials[:phone_no])
          &.authenticate credentials[:password]

    user.create_session if user
    return user
  end

  def blocked?
    status == "blocked"
  end

  def active?
    status == "active"
  end
  
  
  def create_session
    user_session = Session.where(user_id: id).first_or_initialize
    user_session.version = APP_VERRSION
    user_session.save
  end

end
