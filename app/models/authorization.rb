class Authorization < ApplicationRecord
  include Authenticator::Staff::AuthorizationTypes
  belongs_to :user

  validates :type, uniqueness: {scope: [:user_id]}
  validates :type, inclusion: {in: TYPES}
  
  def self.find_by_type auth_type
    find_by(type: auth_type)
  end
end
