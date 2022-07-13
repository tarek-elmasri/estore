class StaffAction < ApplicationRecord

  belongs_to :user

  validates :action, presence: true
  validates :model, presence: true
  validates :model_id, presence: true

  scope :include_user, -> {includes(:user)}
  # finder scopes
  scope :model_type_name, -> (value) {match_key_with_value(:model, value)}
  scope :action_type, -> (value) {match_key_with_value(:action, value)}
  scope :of_model_id, -> (id){where(model_id: id)}
  scope :by_user_id, -> (id) {include_user.where(user: {id: id})}
end
