class Card < ApplicationRecord
  belongs_to :order_item, optional: true
  belongs_to :item

  scope :available, -> {where(active: true)}
  

  def is_active?
    active
  end

  
end
