class Order < ApplicationRecord
  include StripeManager::Base

  attr_accessor :cart

  belongs_to :user
  has_many :order_items , dependent: :destroy


  validates :cart, presence: true , on: :create
  validate :cart_checkout, on: :create

  before_validation :set_user , :build_values, on: :create

  after_create :create_order_items

  after_save :check_status

  scope :not_fullfilled, -> {where.not(status: "succeeded")}
  scope :fullfilled, -> {where(status: "succeeded")}

  class OrderHandler

    attr_reader :order
    def initialize(order)
      self.order=order
    end

    def handle
      order.order_items.each do |oi|
        if oi.is_card?
          Card.attach_codes_to_order_item(oi)
          self.require_delivery = true
        end
        eleminate_stocks(oi)
      end

      # DeliveryManager.new(self.order).deliver_cards if self.require_delivery
    end

    private
    attr_writer :order
    attr_accessor :require_delivery
    def eleminate_stocks(oi)
      item=Item.find(oi.item_id)
      report(oi) unless item.has_stock?
      item.eleminate_quantity(oi.quantity)
    end

    def report(oi)
      # reporting quantites miss count
    end
  end
  def check_status
    if status_changed? && status== 'succeeded'
      OrderHandler
      # # decrementing item stocks after successfull payment
      # order_items.each do |oi|
      #   Item.find(oi.item_id).eleminate_quantity(oi.quantity)
      # end
    end
  end

  private

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
