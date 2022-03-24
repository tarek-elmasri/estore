class Category < ApplicationRecord
# has_many :items, dependent: :destroy
belongs_to :primary_category, class_name: "Category", foreign_key:"primary_category_id"
has_many :sub_categories, class_name: "Category", optional: true
validates :name , presence: true
end
