class User < ApplicationRecord
  include Authenticator::User
  include Authenticator::Staff::Authorization
  
  has_one :cart
  has_many :staff_actions
  
  validates :email, uniqueness:true
  validates :phone_no , uniqueness: true
  validates :gender, inclusion: {in: ['male','female'], message: I18n.t('errors.validations.user.gender')}
  validates :email , presence:true
  validates :first_name , presence: true
  validates :last_name, presence: true
  validates :gender , presence: true
  validates :phone_no, numericality: { only_integer: true, message: I18n.t('errors.validations.user.invalid_phone_no') }
  validate :valid_phone_no

  def valid_phone_no
    unless phone_no.length == 9 && phone_no[0]== "5"
      errors.add(:phone_no, I18n.t('errors.validations.user.invalid_phone_no'))
    end
  end


end
