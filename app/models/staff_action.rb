class StaffAction < ApplicationRecord
  belongs_to :user

  validates :action, presence: true
  validates :action, inclusion: {in: Authorization::TYPES}
  validates :model, presence: true
  validates :model_id, presence: true
  
end
