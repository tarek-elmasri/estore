class Notification < ApplicationRecord
  include Interfaces::Notifications
  
  belongs_to :notifiable , polymorphic: true

  validates :notifiable_id, presence: true
  validates :notifiable_type, presence: true
  validates :msg_type, presence: true

  scope :of_msg_type, -> (required_type) {where(msg_type: required_type)}
  scope :seen,-> {where (seen: true)}
  scope :unseen, -> {where(seen: false)}
  
  def message
    I18n.t("notifications.#{notifiable_type.pluralize.downcase}.#{msg_type}")
  end

  def model_name
    notifiable_type.downcase
  end

  def model_id
    notifiable_id
  end

  def msg_type_is?(required_type)
    required_type == msg_type
  end
end
