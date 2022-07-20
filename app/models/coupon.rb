class Coupon < ApplicationRecord
  include Base64FileAttachment

  has_one_base64_attached :avatar
  validates_attached :avatar, required: true, unless: :ziko
  has_many :users , through: :user_coupons

  attr_accessor :ziko
end
