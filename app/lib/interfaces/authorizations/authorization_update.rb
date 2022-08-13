class Interfaces::Authorizations::AuthorizationUpdate
  include StaffTracker::Recorder

  attr_reader :authorization

  def initialize user_id
    self.authorization = Authorization.where(user_id: user_id).first_or_initialize
  end

  def update! params
    authorize_update
    authorization.update!(params)

    record_action(
      :update,
      "authorization",
      authorization.id
    )

    return authorization
  end

  private
  attr_writer :authorization

  def authorize_update
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_authorization?
  end
end