class Cart < ApplicationRecord
  belongs_to :user
  has_many :items , through: :cart_items
  has_many :cart_items
end
