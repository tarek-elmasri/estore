class OrderItem < ApplicationRecord
  belongs_to :order
  has_many :cards

  validates :value, :t_value, :description, :type_name, presence: true
  validates :delivery_status, inclusion: {in: ['pending', 'delivered', 'partial_delivery', 'failed']}

  scope :only_cards, -> {where(type_name: 'card')}
  scope :include_cards, -> {includes(:cards)}
  def is_card?
    type_name == 'card'
  end

  def is_item?
    type_name == 'item'
  end

  def self.deliver_cards(order)
    return unless order.is_fullfilled?
    order.order_items.only_cards
              .update_all(delivery_status)
  end

end
