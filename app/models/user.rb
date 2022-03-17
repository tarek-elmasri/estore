class User < ApplicationRecord
  include Authenticator::Model
  
  

  has_one :cart
  has_one :session

  validates :email, uniqueness:true
  validates :phone_no , uniqueness: true
  validates :first_name , presence: true
  validates :last_name, presence: true
  validates :gender , presence: true




end
