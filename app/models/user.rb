class User < ApplicationRecord
  include Authenticator::User
  include Authenticator::Staff::Authorization
  
  has_one :cart
  after_create :create_cart

  has_many :staff_actions
  
  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :email,:phone_no, uniqueness:true
  validates :gender, inclusion: {in: ['male','female'], message: I18n.t('errors.validations.user.gender')}
  validates :first_name , length: { minimum: 1, maximum: 20}
  validates :last_name, length: { minimum: 1, maximum: 20}
  validates :phone_no, numericality: { only_integer: true, message: I18n.t('errors.validations.user.invalid_phone_no') }
  validate :valid_phone_no

  def valid_phone_no
    return unless phone_no
    unless phone_no.length == 9 && phone_no[0]== "5"
      errors.add(:phone_no, I18n.t('errors.validations.user.invalid_phone_no'))
    end
  end

  private

  def create_cart
    Cart.create(user_id: id)
  end



end
