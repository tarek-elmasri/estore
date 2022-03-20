class User < ApplicationRecord
  include Authenticator::User
  include Authenticator::Staff::Authorization
  
  has_one :cart
  has_many :staff_actions
  
  validates :email, uniqueness:{message: I18n.t("errors.validations.uniqueness")}
  validates :phone_no , uniqueness: {message: I18n.t("errors.validations.uniqueness")}
  validates :gender, inclusion: {in: ['male','female'], message: I18n.t('errors.validations.user.gender')}
  validates :email , presence:{message: I18n.t('errors.validations.required')}
  validates :phone_no, presence:{message: I18n.t('errors.validations.required')}
  validates :first_name , presence: {message: I18n.t('errors.validations.required')}
  validates :last_name, presence: {message: I18n.t('errors.validations.required')}
  validates :gender , presence: {message: I18n.t('errors.validations.required')}




end
