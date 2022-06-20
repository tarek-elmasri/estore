class Card < ApplicationRecord
  belongs_to :order_item, optional: true
  belongs_to :item

  scope :available, -> {where(active: true, order_item_id: nil).order(created_at: :asc)}
  

  def self.attach_codes_to_order_item(oi)
    cards = Card.available.where(item_id: oi.item_id)
                .limit(oi.quantity)
                .order(created_at: :asc)

    # update_all escapes callbacks and validations
    cards.update_all(order_item_id: oi.id, active: false)
  end

  def is_active?
    active
  end

  
end
