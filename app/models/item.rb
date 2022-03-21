class Item < ApplicationRecord
  belongs_to :category
  has_many :carts , through: :cart_items
  has_many :cart_items, dependent: :destroy

  validates :type,:name, presence: true
  validates :price, numericality: true
  validates :stock, presence: true , if: :has_limited_stock
  validates :stock, numericality: {only_integer: true}, allow_nil: true
  validates :low_stock, presence: true , if: :notify_on_low_stock
  validates :low_stock, numericality: {only_integer: true}, allow_nil: true
  validates :cost, numericality: true, allow_nil: true
  validates :discount_price,:discount_end_date,:discount_start_date, presence: true, if: :has_discount
  validates :discount_price, numericality: true, allow_nil: true
  validates :max_quantity_per_customer, presence: true, if: :limited_quantity_per_customer
  validates :max_quantity_per_customer, numericality: {only_integer: true}, allow_nil: true


  private
  
  
end
