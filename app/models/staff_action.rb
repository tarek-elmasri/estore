class StaffAction < ApplicationRecord
  belongs_to :user

  validates :action, presence: true
  validates :model, presence: true
  validates :model_id, presence: true
  
end
