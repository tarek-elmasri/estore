class User < ApplicationRecord
  include Authenticator::User
  include Authenticator::Staff::Authorization
  
  has_one :cart
  has_many :staff_actions
  

  validates :email, uniqueness:true
  validates :phone_no , uniqueness: true
  validates :first_name , presence: true
  validates :last_name, presence: true
  validates :gender , presence: true



end
