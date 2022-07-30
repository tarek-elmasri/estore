class Interfaces::Notifications::NotificationUpdate

  attr_reader :notification, :skip_authorization

  def initialize(notification, skip_authorization=false)
    self.notification= notification
    self.skip_authorization= skip_authorization
  end

  def update! params
    check_authorization unless skip_authorization
    notification.update!(params)

    return notification
  end

  private
  attr_writer :notification, :skip_authorization
  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_notification?
  end
end