class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notifiable_id: , notifiable_type: , msg_type:)
    Notification::NotificationCreation.new(

    )
  end
end
