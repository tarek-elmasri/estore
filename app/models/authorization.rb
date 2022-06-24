class Authorization < ApplicationRecord
  include Authenticator::Staff::AuthorizationTypes
  include Authenticator::Staff::ModelAuthorizationChecker
  include StaffTracker::Model

  belongs_to :user

  after_initialize :handle_collection
  before_validation :generate_collection
  validate :user_rule

  private
  def generate_collection
    payload= ""

    TYPES.each do |t|
      if (send(t))
        payload = payload + "#{t};"
      end
    end
    self.collection = payload
  end

  def handle_collection
    return unless collection
    collection.split(";").each do |t|
                send("#{t}=", true)
    end
  end

  def user_rule
    return unless user
    errors.add(:user, I18n.t("errors.authorization.auth_for_staff_only")) unless user.is_staff? || user.is_admin?
  end

  

  
end
