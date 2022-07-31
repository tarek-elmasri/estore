class Interfaces::Notifications::NotificationCreation

  attr_reader :notification

  def initialize(notifiable_id: , notifiable_type: , msg_type:) 

    self.notification = Notification.new(
      notifiable_id: notifiable_id,
      notifiable_type: notifiable_type,
      msg_type: msg_type
    )
  end

  def create!
    notification.save!
    return notification
  end

  private
  attr_writer :notification

end