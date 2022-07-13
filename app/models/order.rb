class Order < ApplicationRecord
  include StripeManager::Base
  include Interfaces::Orders
  
  attr_accessor :cart

  validates :status, :t_value, :t_vat, :t_payment, :delivery_status, presence: true
  validates :t_value, :t_vat, :t_payment, numericality: true
  

  belongs_to :user
  has_many :order_items , dependent: :destroy

  scope :not_fullfilled, -> {where.not(status: "succeeded")}
  scope :fullfilled, -> {where(status: "succeeded")}
  scope :include_user, -> {includes(:user)}
  scope :include_order_items, -> {includes(:order_items)}

  # finder scoped -------
  scope :only_cards, -> {include_order_items.where(order_items: {type_name: 'card'})}
  scope :delivered, -> {where(delivery_status: 'delivered')}
  scope :pending_delivery, -> { where(delivery_status: ['partial_delivery','pending'])}
  scope :failed_delivery, -> {where( delivery_status: 'failed')}
  #--------

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

end
