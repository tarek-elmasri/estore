class User < ApplicationRecord
  include Authenticator::User
  include Authenticator::Staff::Authorization
  
  has_one :cart
  has_many :staff_actions
  
  validates :email, uniqueness:true
  validates :phone_no , uniqueness: true
  validates :gender, inclusion: {in: ['male','female'], message: I18n.t('errors.validations.user.gender')}
  validates :email , presence:true
  validates :phone_no, presence:true
  validates :first_name , presence: true
  validates :last_name, presence: true
  validates :gender , presence: true




end
