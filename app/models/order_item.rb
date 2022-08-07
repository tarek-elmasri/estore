class OrderItem < ApplicationRecord
  include Interfaces::OrderItems
  
  belongs_to :order
  has_many :cards

  validates :quantity, :value, :t_value, :description, :type_name, :item_id,:delivery_status, presence: true
  validates :delivery_status, inclusion: {in: ['pending', 'delivered', 'partial_delivery', 'failed'], message: I18n.t("errors.validations.order_item.delivery_status")}
  validates :quantity, numericality: {only_integer: true}
  validates :value, :t_value, numericality: true

  scope :only_cards, -> {where(type_name: 'card')}
  scope :include_cards, -> {includes(:cards)}
  scope :include_order, -> {includes(:order)}
  
  def is_card?
    type_name == 'card'
  end

  def has_cards?
    return false unless is_card?
    cards.any?
  end

  def is_item?
    type_name == 'item'
  end

  def is_delivered?
    delivery_status == 'delivered'
  end

  def is_pending?
    delivery_status == 'pending'
  end

  def is_failed?
    delivery_status == 'failed'
  end

end
