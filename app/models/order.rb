class Order < ApplicationRecord
  include StripeManager::Base
  include StaffTracker::Model
  
  attr_accessor :cart

  belongs_to :user
  has_many :order_items , dependent: :destroy


  validates :cart, presence: true , on: :create
  validate :cart_checkout, on: :create

  before_validation :set_user , :build_values, on: :create

  after_create :create_order_items

  before_save :set_should_handle
  after_save :handle_order

  scope :not_fullfilled, -> {where.not(status: "succeeded")}
  scope :fullfilled, -> {where(status: "succeeded")}

  def is_fullfilled?
    status == 'succeeded'
  end

  private
  attr_accessor :should_handle

  def set_should_handle
    self.should_handle = (status_changed? && status == 'succeeded')
  end
  
  # pm_1LDOInAsVHY13rlefyeYwayU

  def handle_order
    OrderHandler::Stocks.new(self).handle if should_handle
  end

  def set_user
    return unless self.cart
    self.user_id =  self.cart.user_id
  end

  def build_values
    return unless self.cart

    self.t_value = 0.00
    #TODO implement vat mechanism
    self.t_vat = 0.00
    self.cart.cart_items.each do |ci|
      self.t_value += ci.item.has_discount ? ci.item.discount_price : ci.item.price
    end

    self.t_payment= self.t_value + self.t_vat
    
  end

  def create_order_items
    return unless self.cart

    order_items_array =[]
    self.cart.cart_items.include_item.each do |ci|
      oi= {
        order_id: id,
        quantity: ci.quantity,
        value: ci.item.has_discount ? ci.item.discount_price : ci.item.price,
        description: ci.item.name,
        item_id: ci.item_id,
        type_name: ci.item.type_name
      }
      oi[:t_value] = oi[:quantity] * oi[:value]
      order_items_array.push(oi)
    end

    OrderItem.create!(order_items_array)
  end

  def cart_checkout
    return unless self.cart
    unless self.cart.valid_for_checkout?
      errors.add(:cart , self.cart.checkout_errors)
    end
  end



end
