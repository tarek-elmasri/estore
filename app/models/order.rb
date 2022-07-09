class Order < ApplicationRecord
  include StripeManager::Base
  #include StaffTracker::Model
  include Interfaces::Orders
  
  attr_accessor :cart

  belongs_to :user
  has_many :order_items , dependent: :destroy

  #before_validation :set_user , :build_values, on: :create

  #validates :cart, presence: true , on: :create
  
  #validate :cart_checkout, on: :create
  #before_create :cart_checkout

  #after_create :create_order_items, :create_cleanup_job

  #before_save :set_should_handle
  #after_save_commit :handle_order

  scope :not_fullfilled, -> {where.not(status: "succeeded")}
  scope :fullfilled, -> {where(status: "succeeded")}
  scope :include_user, -> {includes(:user)}
  scope :include_order_items, -> {includes(:order_items)}
  #scope :include_order_cards, -> {includes(order_items: [:cards])}

  def is_fullfilled?
    status == 'succeeded'
  end

  def has_cards_attached?
    order_items.include_cards.any?{|oi| oi.is_card? && oi.has_cards?}
  end

  def deliver_cards
    return unless has_cards_attached?
    CardsMailer.deliver_cards(id).deliver_later
  end

  # private
  # #attr_accessor :should_handle

  # # def set_should_handle
  # #   self.should_handle = (status_changed? && status == 'succeeded')
  # # end

  # def handle_order
  #   if (status_previously_changed? && self.status == 'succeeded')
  #     OrderHandlerJob.perform_later(self.id)
  #     InvoicesMailer.send_invoice(self.id).deliver_later
  #   end
  # end

  # def set_user
  #   return unless self.cart
  #   self.user_id =  self.cart.user_id
  # end

  # def build_values
  #   return unless self.cart

  #   self.t_value = 0.00
  #   #TODO implement vat mechanism
  #   self.t_vat = 0.00
  #   self.cart.cart_items.each do |ci|
  #     self.t_value += (ci.item.has_discount ? ci.item.discount_price : ci.item.price) * ci.quantity
  #   end

  #   self.t_payment= self.t_value + self.t_vat
    
  # end

  # def create_order_items
  #   return unless self.cart

  #   order_items_array =[]
  #   self.cart.cart_items.include_item.each do |ci|
  #     oi= {
  #       order_id: id,
  #       quantity: ci.quantity,
  #       value: ci.item.has_discount ? ci.item.discount_price : ci.item.price,
  #       description: ci.item.name,
  #       item_id: ci.item_id,
  #       type_name: ci.item.type_name
  #     }
  #     oi[:t_value] = oi[:quantity] * oi[:value]
  #     order_items_array.push(oi)
  #   end

  #   OrderItem.create!(order_items_array)
  # end

  # def cart_checkout

  #   return unless self.cart
  #   throw(:abort)
  #   #self.cart.checkout
  # # rescue
  # #   errors.add(:cart, self.cart.checkout_errors)
  # #   #return false
  # end

  # def create_cleanup_job
  #   OrderCleanupJob.set(wait: 24.hours).perform_later(id)
  # end


end
