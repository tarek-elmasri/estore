class Category < ApplicationRecord
  include Interfaces::Categories

  has_many :item_categories, dependent: :destroy
  has_many :items, through: :item_categories
  belongs_to :primary_category, class_name: "Category", optional: true

  has_many :sub_categories, class_name: "Category", foreign_key:"primary_category_id", dependent: :destroy

  validates :name , presence: true
  validates :primary_category, presence: true , if: :primary_category_id

  # scopes for finders ----
    scope :primary, -> {where(primary_category_id: nil)}
    scope :name_like, -> (value)  {match_key_with_value(:name, value)}
    scope :only_pinned, -> { where(pinned: true) }
  #-------


end
