class Item < ApplicationRecord
  include Authenticator::Staff::ModelAuthorizationChecker
  include StaffTracker::Model
  
  
  has_many :item_categories, dependent: :destroy
  has_many :categories, through: :item_categories
  has_many :cart_items, dependent: :destroy
  has_many :carts , through: :cart_items
  has_many :cards
  
  accepts_nested_attributes_for :item_categories, allow_destroy: true
  
  before_validation :set_stock_to_zero,if: :is_card?,  on: :create

  validates :name, presence: true
  validates :type_name, inclusion: { in: ['card' , 'item']}
  validates :price, numericality: true
  validate :stock_set_to_limited , if: :is_card?
  validates :stock, presence: true , if: :has_limited_stock
  validate :stock_didnt_change ,if: :is_card?, unless: :new_record?
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
  scope :available, -> {where(available: true)}
  
  def is_card?
    type_name == 'card'
  end

  def has_stock?( amount = 1)
    return true unless has_limited_stock
    return true if stock && stock >= amount
    return false
  end

  def multi_quantity_allowed?
    allow_multi_quantity
  end

  def duplicate_allowed?
    allow_duplicate
  end

  def is_available?
    #TODO : add field available to item and switch availability according item removed from dashboard or not
    # and keep visible to its appearence in shop nor hide
    visible  && available
  end

  def eleminate_quantity(amount)
    # decrement escapes is authorized to function
    # and should be called only after order successfully completed
    return unless has_limited_stock
    if has_stock?(amount)
      decrement!(:stock, amount)
    else
      decrement!(:stock , stock)
    end
  end

  private
  def set_stock_to_zero
    if stock && stock > 0
      errors.add(:stock, I18n.t('errors.item.stock_must_be_zero'))
      return
    end
    self.stock = 0 
  end

  def stock_set_to_limited
    unless has_limited_stock
      errors.add(:has_limited_stock, I18n.t('errors.item.must_limited_stock'))
    end
  end

  def stock_didnt_change
    if stock_changed?
      errors.add(:stock, I18n.t('errors.item.card_stock_change'))
    end
  end

  def discount_dates
    return unless discount_start_date || discount_end_date
    
  end
  
end
