class OrderItem < ApplicationRecord
  include Interfaces::OrderItems
  
  belongs_to :order
  has_many :cards

  validates :value, :t_value, :description, :type_name, presence: true
  validates :delivery_status, inclusion: {in: ['pending', 'delivered', 'partial_delivery', 'failed']}

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
