class Coupon < ApplicationRecord
  include StaffTracker::Model

has_many :users , through: :user_coupons
end
