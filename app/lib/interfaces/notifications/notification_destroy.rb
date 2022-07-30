class Interfaces::Notifications::NotificationDestroy

  attr_reader :notification, :skip_authorization

  def initialize(notification, skip_authorization=false)
    self.notification= notification
    self.skip_authorization= skip_authorization
  end

  def destroy!
    check_authorization unless skip_authorization
    notification.destroy!

    return notification
  end

  private
  attr_writer :notification, :skip_authorization

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_delete_notification?
  end
end