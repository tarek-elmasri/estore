class Item < ApplicationRecord
  include Interfaces::Items
  # include Authenticator::Staff::ModelAuthorizationChecker
  # include StaffTracker::Model
  
  has_one :item_stock
  has_many :item_categories, dependent: :destroy
  has_many :categories, through: :item_categories
  has_many :cart_items, dependent: :destroy
  has_many :carts , through: :cart_items
  has_many :cards
  
  default_scope {includes(:item_stock)}

  accepts_nested_attributes_for :item_categories, allow_destroy: true
  
  before_validation :set_stock_to_zero,if: :is_card?,  on: :create

  validates :name, presence: true
  validates :type_name, inclusion: { in: ['card' , 'item']}
  validates :price, numericality: true
  validates :has_limited_stock, inclusion: {in: [true,false,nil]}
  validate :stock_set_to_limited , if: :is_card?
  validates :stock, presence: true , if: :has_limited_stock
  validate :stock_didnt_change ,if: :is_card?, unless: :new_record?
  validates :stock, numericality: {only_integer: true}, allow_nil: true
  validates :notify_on_low_stock, inclusion: {in: [true , false , nil]}
  validates :low_stock, presence: true , if: :notify_on_low_stock
  validates :low_stock, numericality: {only_integer: true}, allow_nil: true
  validates :cost, numericality: true, allow_nil: true
  validates :discount_price,:discount_end_date,:discount_start_date, presence: true, if: :has_discount
  validates :discount_price, numericality: true, allow_nil: true
  validates :max_quantity_per_customer, presence: true, if: :limited_quantity_per_customer
  validates :max_quantity_per_customer, numericality: {only_integer: true}, allow_nil: true

  validate :discount_dates

  validate :stock_is_zero, if: :is_card?, on: :create
  #after_save :handle_stock

  scope :visible, -> {where(visible: true)}
  scope :available, -> {where(available: true)}
  # scopes for finders 
  scope :of_category_ids, -> (ids=[]) {includes(:item_categories).where(item_categories: {category_id: ids})}
  scope :of_category_id, -> (id) { of_category_ids(id) }
  scope :only_cards, ->  {where(type_name: 'card')}
  scope :has_discount, -> {where(has_discount: true)}
  # ---


  def is_card?
    type_name == 'card'
  end

  def has_cards?
    cards.available.any?
  end

  # old version of stock handling
  # def has_stock?( amount = 1)
  #   return true unless has_limited_stock
  #   return true if stock && stock >= amount
  #   return false
  # end
  def has_stock?(amount = 1)
    item_stock.has_active_stock?(amount)
  end

  def multi_quantity_allowed?
    allow_multi_quantity
  end

  def duplicate_allowed?
    allow_duplicate
  end

  def is_available?
    visible  && available
  end

  def active_stock
    item_stock.active
  end

  def pending_stock
    item_stock.pending
  end

  def sold_quantity
    item_stock.sales
  end

  # #old version
  # # decrement escapes authorization validations
  # def eleminate_quantity(amount)
  #   return unless has_limited_stock
  #   if has_stock?(amount)
  #     decrement!(:stock, amount)
  #   else
  #     decrement!(:stock , stock)
  #   end
  # end


  # def reserve_quantity!(amount)
  #   item_stock.move_to_pending!(amount)
  # end

  # def sell_quantity!(amount)
  #   item_stock.sell!(amount)
  # end

  # # escapes authorization validation
  # def add_to_stock(amount)
  #   return unless has_limited_stock
  #   increment!(:stock,amount)
  # end

  # def terminate!
  #   raise Errors::Unauthorized unless Current.user.is_authorized_to_delete_item?
  #   if is_card? && has_cards?
  #     raise Errors::ItemHasCardsError
  #   end

  #   update_columns(visible: false, available: false)
  # end

  private
  
  def stock_is_zero
    return if stock == 0
    errors.add(:stock, I18n.t('errors.item.stock_must_be_zero'))
  end

  def set_stock_to_zero
    return if stock
    # if stock && stock > 0
    #   errors.add(:stock, I18n.t('errors.item.stock_must_be_zero'))
    #   return
    # end
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
