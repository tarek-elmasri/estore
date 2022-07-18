class Coupon < ApplicationRecord
  include FileUploader

  has_one_file :avatar , required: true, accepted_content_types: ['image/png'], max_file_size: 1000000
  has_one_file :ziko, accepted_content_types: ['image/jpeg']
  has_many :users , through: :user_coupons
end
