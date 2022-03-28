class UserCoupon < ApplicationRecord
  include StaffTracker::Model

  belongs_to :user
  belongs_to :coupon
end
