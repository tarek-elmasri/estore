class Coupon < ApplicationRecord
  include FileUploader

  #has_one_file :avatar , required: true, accepted_content_types: ['image/jpeg'], max_file_size: 1000000
  # has_one_file :ziko, accepted_content_types: ['image/jpeg']
  #has_one_attached :ziko#, validation_options: {hello: "str"}
  has_one_attached :avatars
  has_many :users , through: :user_coupons

  validates_with AttachmentValidator, cc: 'dd'
end
