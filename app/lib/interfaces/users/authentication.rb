class Interfaces::Users::Authentication

  def self.login credentials
    raise ActiveRecord::RecordNotFound if credentials[:phone_no].blank? || credentials[:password].blank?
        
    user = User.find_by(phone_no: credentials[:phone_no])
          &.authenticate credentials[:password]

    raise ActiveRecord::RecordNotFound unless user
    raise Errors::BlockedUser if user.blocked?
    self.handle_refresh_token(user)
    self.create_session(user.id)
    return user
  end

  def self.register params
    User.transaction do
      user= User.new(params)
      user.should_validate_password = true
      user.save!
      self.create_cart(user.id)
      self.create_session(user.id)
    end

    return user
  end

  private
  def self.create_session(id)
    Session.create_or_update(id)
  end

  def self.create_cart(id)
    Cart.create(user_id: id)
  end

  def self.handle_refresh_token user
    # reset if is not valid anymore
    begin
      decoder = JwtHandler::Decoder.new(user.refresh_token, :refresh_token)
    rescue => exception
      user.reset_refresh_token
    end
  end

end