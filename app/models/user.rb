class User < ApplicationRecord
  include Authenticator::User
  include Authenticator::Staff::Authorization
  include Interfaces::Users

  DIRTY_CHARACTERS =['(',')','{','}','[',']','|',"`","¬","¦", '"',
                      '^','*',"'",'<','>',':',';',"~","_","-","+"]
  PASS_PATTERN = /\A(?=.*{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[@!$%*]])/x
  
  has_many :staff_actions
  has_many :orders
  has_one :cart
  has_many :cart_items , through: :cart
  has_one_base64_attached :avatar, dependent: :purge_later

  attr_accessor :should_validate_password

  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\Z/i }
  validates :email,:phone_no, uniqueness:true
  validates :password, length: {minimum: 6}, if: :should_validate_password
  validate :password_pattern, if: :should_validate_password
  validates :city, length: {maximum: 253}
  validates :gender, inclusion: {in: ['male','female'], message: I18n.t('errors.validations.user.gender')}
  validates :first_name , length: { minimum: 2, maximum: 20}
  validates :last_name, length: { minimum: 2, maximum: 20}
  validates :phone_no, numericality: { only_integer: true, message: I18n.t('errors.validations.user.invalid_phone_no') }
  validates :status, inclusion: {in: ['active', 'blocked'] , message: I18n.t('errors.validations.user.status')}
  validate :valid_phone_no
  validate :valid_dob
  validates_attached :avatar, content_type: ['image/jpeg','image/jpg', 'image/png'], max_file_size: 1000000


  scope :load_with_cart_and_authorization, ->(id) {
    User.includes(:cart)
        .includes(:authorization)
        .find(id)
  }

  scope :include_authorization, -> {includes(:authorization)}
  # finder scoopes
  scope :only_blocked, -> {where(blocked: true)}
  scope :exclude_id, -> (id=nil) {where.not(id: id)}
  scope :by_gender, -> (value) { where(gender: value) }
  scope :by_phone_no, -> (value) { where(phone_no: value) }
  scope :by_email, -> (value) { where(email: email) }
  scope :by_city, -> (value) { where(city: value)}
  scope :only_staff, -> { where( rule: ['admin','staff']) }
  scope :age_above,-> (value) {where(arel_table[:dob].lt(get_dob_from_age(value))) if valid_age?(value)}
  scope :age_below,-> (value) {where(arel_table[:dob].gt(get_dob_from_age(value))) if valid_age?(value)}
  scope :age_between, lambda { |age_range=[]|
    where(
      arel_table[:dob]
            .between(get_dob_from_age(age_range.first)..get_dob_from_age(age_range.last))
    ) if valid_age?(age_range.first) && valid_age?(age_range.last)
  }
  #-----
    

  def get_full_cart
    Cart.includes(cart_items: [:item]).find_by(user_id: self.id)
  end

  
  
  def self.get_dob_from_age age
    return age.to_i.years.ago if valid_age?(age)
  end
  def self.valid_age? age
    return true if Integer(age, exception:false)
    false
  end
  
  private
  def password_pattern
    return unless password
    unless Regexp.new(PASS_PATTERN).match?(password)
      errors.add(:password, I18n.t('errors.validations.password.invalid_pattern'))
    end
    if password.split('').any?{|char| DIRTY_CHARACTERS.include?(char)}
      errors.add(:password, I18n.t('errors.validations.password.dirty_characters'))
    end
  end

  def valid_phone_no
    return unless phone_no
    unless phone_no.length == 9 && phone_no[0]== "5"
      errors.add(:phone_no, I18n.t('errors.validations.user.invalid_phone_no'))
    end
  end

  def valid_dob
    return unless dob
    if dob < Date.today
      errors.add(:dob, I18n.t('errors.validations.user.invalid_dob'))
    end
  end
end
