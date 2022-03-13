class Item < ApplicationRecord
  belongs_to :category
  has_many :carts , through: :cart_items
end
