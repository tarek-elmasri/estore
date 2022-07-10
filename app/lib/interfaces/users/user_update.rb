class Interfaces::Users::UserUpdate

  attr_reader :user

  def initialize user
    self.user=user
  end

  def update! params
    User.transaction do
      authorize_update
      authorize_authorization_update if user.rule_changed?
      user.update!(params)
      destroy_authorizations if user.is_admin? || user.is_user?
    end
    
    return user
  end

  private
  attr_writer :user

  def authorize_update
    raise Errors::Unauthorized unless Current.user.id == user.id || Current.user.is_authorized_to_update_user?
  end

  def authorize_authorization_update
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_authorization?
    raise Errors::Unauthorized if self.rule == "admin" && Current.user.rule == "staff"
  end

  def destroy_authorizations
    user.authorization&.destroy
  end

end