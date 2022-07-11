class Interfaces::Users::UserUpdate
  include StaffTracker::Recorder

  attr_reader :user

  def initialize user
    self.user=user
  end

  def update! params
    authorize_update()
    authorize_rule_update(params[:rule])
    authorize_status_update(params[:status])
    User.transaction do
      user.update!(params)
      destroy_authorizations if user.is_admin? || user.is_user?
    end
  
    if updated_by_staff?
      record(
        :update,
        "user",
        user.id
      )
    end

    return user
  end

  private
  attr_writer :user

  def authorize_update
    raise Errors::Unauthorized unless Current.user.id == user.id || Current.user.is_authorized_to_update_user?
  end

  def rule_changed? rule
    return false unless rule
    return false if user.rule == rule
    true
  end

  def authorize_rule_update(rule)
    if rule_changed?(rule)
      #have authorization to update rule
      raise Errors::Unauthorized unless Current.user.is_authorized_to_update_authorization?
      # staff account cant change rule of an admin
      raise Errors::Unauthorized if user.is_admin? && Current.user.is_staff?
      # staff account cant raise his rule to an admin
      raise Errors::Unauthorized if rule == "admin" && Current.user.is_staff?
    end
  end

  def authorize_status_update status
    return unless status
    unless status == user.status
      raise Errors::Unauthorized unless Current.user.is_authorized_to_update_user_status?
    end
  end

  def destroy_authorizations
    user.authorization&.destroy
  end

  def updated_by_staff?
    Current.user.is_admin? || Current.user.is_staff?
  end

end