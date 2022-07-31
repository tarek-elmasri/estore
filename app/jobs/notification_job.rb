class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notifiable_id: , notifiable_type: , msg_type:)
    Notification::NotificationCreation.new(
      notifiable_id: notifiable_id,
      notifiable_type: notifiable_type,
      msg_type: msg_type
    ).create!
  end
end
