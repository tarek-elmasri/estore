class Interfaces::Notifications::NotificationCreation

  attr_reader :notification

  def initialize(model: , msg_type:) 
    raise ArgumentError.new("#{model.class} is not notifiable") unless model.respond_to?(:notifications)

    self.notification = model.notifications.build(msg_type: msg_type)
  end

  def create!
    notification.save!
    return notification
  end

  private
  attr_writer :notification

end