class Category < ApplicationRecord
  include Authenticator::Staff::ModelAuthorizationChecker
  include StaffTracker::Model

  has_many :item_categories, dependent: :destroy
  has_many :items, through: :item_categories
  belongs_to :primary_category, class_name: "Category", optional: true

  has_many :sub_categories, class_name: "Category", foreign_key:"primary_category_id", dependent: :destroy

  validates :name , presence: true
  validates :primary_category, presence: true , if: :primary_category_id

  
end
