class Item < ApplicationRecord
  include Authenticator::Staff::ModelAuthorizationChecker
  
  
  has_many :item_categories, dependent: :destroy
  has_many :categories, through: :item_categories
  has_many :cart_items, dependent: :destroy
  has_many :carts , through: :cart_items
  
  accepts_nested_attributes_for :item_categories, allow_destroy: true
  
  validates :type_name,:name, presence: true
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

  validate :discount_dates

  scope :visible, -> {where(visible: true)}

  def has_stock?( amount = 1)
    return true unless has_limited_stock
    return true if stock && stock > amount
    return false
  end

  private
  def discount_dates
    return unless discount_start_date || discount_end_date
    
  end
  
end
