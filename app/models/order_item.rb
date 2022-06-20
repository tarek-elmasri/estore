class OrderItem < ApplicationRecord
  belongs_to :order
  has_many :cards

  scope :only_cards, -> {where(type_name: 'card')}
  
  def is_card?
    type_name == 'card'
  end
end
