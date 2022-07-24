class Coupon < ApplicationRecord

  has_many :users , through: :user_coupons

end
