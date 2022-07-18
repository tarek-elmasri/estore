class Coupon < ApplicationRecord
  include FileUploader

  has_many :users , through: :user_coupons
end
