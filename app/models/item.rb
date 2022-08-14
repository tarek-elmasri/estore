class Item < ApplicationRecord
  include Interfaces::Items
  include PresignedUploader::Model

  default_scope {includes(:item_stock).with_attached_images}

  has_one :item_stock, dependent: :destroy
  has_many :item_categories, dependent: :destroy
  has_many :categories, through: :item_categories
  has_many :cart_items, dependent: :destroy
  has_many :carts , through: :cart_items
  has_many :cards, dependent: :destroy
  has_many :notifications, as: :notifiable
  has_many_files :images, file_size: 2000000, content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'], dependent: :purge_later

  accepts_nested_attributes_for :item_categories, allow_destroy: true



  attr_writer :has_limited_stock,:stock,:notify_on_low_stock,:low_stock
  # after_initialize {
  #   self.has_limited_stock ||= item_stock&.has_limited_stock
  #   self.stock ||= item_stock&.active
  #   self.notify_on_low_stock ||= item_stock&.notify_on_low_stock
  #   self.low_stock ||= item_stock&.low_stock
  # }

  before_validation :set_stock_to_zero,if: :is_card?,  on: :create

  validates :name, presence: true
  validates :name, length: { maximum: 253}
  validates :type_name, inclusion: { in: ['card' , 'item'], message: I18n.t("errors.validations.item.type_name")}
  validates :price, numericality: true
  validates :has_limited_stock, inclusion: {in: [true,false,nil]}
  validate :stock_set_to_limited , if: :is_card?
  validates :stock, presence: true , if: :has_limited_stock, unless: :is_card?
  validates :stock, numericality: {only_integer: true}, allow_nil: true
  validates :notify_on_low_stock, inclusion: {in: [true , false, nil]}
  validates :low_stock, presence: true , if: :notify_on_low_stock
  validates :low_stock, numericality: {only_integer: true}, allow_nil: true
  validates :cost, numericality: true, allow_nil: true

  validates :discount_price, presence: true, if: Proc.new{ |m| (m.discount_start_date? || m.discount_end_date?) }
  validates :discount_price, numericality: true, allow_nil: true
  validates :discount_start_date, presence: true , if: :discount_end_date?
  validates :discount_end_date, presence: true, if: :discount_start_date?
  validate :discount_dates
  
  validates :max_quantity_per_customer, presence: true, if: :limited_quantity_per_customer
  validates :max_quantity_per_customer, numericality: {only_integer: true}, allow_nil: true

  scope :visible, -> {where(visible: true)}
  scope :available, -> {visible.where(available: true)}
  scope :include_categories, -> {includes(item_categories: [:category])}
  # scopes for finders 
  scope :not_available, ->{visible.where(available: false)}
  scope :of_category_ids, -> (ids=[]) {includes(:item_categories).where(item_categories: {category_id: ids})}
  scope :of_category_id, -> (id) { of_category_ids(id) }
  scope :only_cards, ->  {where(type_name: 'card')}
  scope :has_discount, -> {where(has_discount: true)}
  scope :order_by_best_sales, -> {includes(:item_stock).order('item_stocks.sales DESC')}
  scope :order_by_high_price,-> {order(price: :desc)}
  scope :order_by_low_price, -> {order(price: :asc)}
  scope :order_by_low_stock, -> {includes(:item_stock).order("item_stocks.active ASC")}
  scope :order_by_high_stock, -> {includes(:item_stock).order("item_stocks.active DESC")}
  scope :empty_stock, -> {includes(:item_stock).where(item_stock: {active: 0})}
  scope :low_stock,-> {includes(:item_stock).where(item_stocks: {has_limited_stock: true}).where('item_stocks.active <= item_stocks.low_stock')}
  scope :only_limited_stock, -> {includes(:item_stock).where(item_stocks: {has_limited_stock: true})}
  scope :only_unlimited_stock, -> {includes(:item_stock).where(item_stocks: {has_limited_stock: false})}
  scope :name_like, -> (value) {match_key_with_value(:name, value)}
  scope :only_pinned, -> { where(pinned: true) }
  # ---


  def is_card?
    type_name == 'card'
  end

  def has_cards?
    cards.available.any?
  end

  def has_stock?(amount = 1)
    item_stock.has_active_stock?(amount)
  end

  def multi_quantity_allowed?
    allow_multi_quantity?
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

  # def image_url(expires_in: 30.minutes)
  #   attachment = image.attachment
  #   return unless attachment
  #   return {
  #     attachment_id: image.attachment.id,
  #     url: image.url(expires_in: expires_in)
  #   }
  # end
#------ instead of after initialize solution ----------------
  def has_limited_stock
    @has_limited_stock.nil?  ? item_stock&.has_limited_stock : @has_limited_stock
  end

  def has_limited_stock?
    !!has_limited_stock
  end

  def stock
    @stock.nil? ? item_stock&.active : @stock
  end

  def notify_on_low_stock
    @notify_on_low_stock.nil? ? item_stock&.notify_on_low_stock : @notify_on_low_stock
  end

  def notify_on_low_stock?
    !!notify_on_low_stock
  end

  def low_stock
    @low_stock.nil? ?  item_stock&.low_stock : @low_stock
  end

  def low_stock?
    !!low_stock
  end
  private
  

  def set_stock_to_zero
    #return if stock
    self.stock = 0 
  end

  def stock_set_to_limited
    unless has_limited_stock
      errors.add(:has_limited_stock, I18n.t('errors.validations.item.must_limited_stock_with_card'))
    end
  end

  def stock_didnt_change
    if stock_changed?
      errors.add(:stock, I18n.t('errors.item.card_stock_change'))
    end
  end

  def discount_dates
    return unless discount_start_date? && discount_end_date?
    if discount_start_date >= discount_end_date
      errors.add(:discount_start_date, I18n.t('errors.validations.item.discount_start_date_invalid'))
    end
  end
  
end
