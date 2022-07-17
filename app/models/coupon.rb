class Coupon < ApplicationRecord
  include UploadValidator

  has_one_file :avatar, maximum_file_size: 1000
  has_many :users , through: :user_coupons
end
