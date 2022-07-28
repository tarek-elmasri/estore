class Notification < ApplicationRecord

  belongs_to :notifiable , polymorphic: true

  validates :notifiable_id, presence: true
  validates :notifiable_type, presence: true
  validates :msg_type, presence: true


  def message
    I18n.t("notifications.#{notifiable_type.pluralize}.#{msg_type}")
  end

  def model_name
    notifiable_type
  end

  def model_id
    notifiable_id
  end
end
