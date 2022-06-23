class OrderItem < ApplicationRecord
  belongs_to :order
  has_many :cards

  validates :code, :value, :t_value, :description, :type_name, presence: true
  validates :delivery_status, inclustion: {in: ['pending', 'delivered', 'partial_delivery', 'failed']}

  scope :only_cards, -> {where(type_name: 'card')}

  def is_card?
    type_name == 'card'
  end

  def is_item?
    type_name == 'item'
  end
end
