class Category < ApplicationRecord
has_many :items, through: :item_categories, dependent: :destroy
belongs_to :primary_category, class_name: "Category", optional: true
has_many :sub_categories, class_name: "Category", foreign_key:"primary_category_id"

validates :name , presence: true

end
