class Card < ApplicationRecord
  include Authenticator::Staff::ModelAuthorizationChecker
  include StaffTracker::Model

  belongs_to :order_item, optional: true
  belongs_to :item

  validates :order_item, presence: true, if: :order_item_id
  validates :item, :code, presence: true
  validate :item_is_visible, :item_is_card

  after_create :add_stock_to_item
  before_destroy :card_is_active
  after_destroy :remove_stock_from_item

  scope :available, -> {where(active: true, order_item_id: nil).order(created_at: :asc)}
  

  def self.attach_codes_to_order_item(oi)
    cards = Card.available.where(item_id: oi.item_id)
                .order(created_at: :asc)
                .limit(oi.quantity)

    # update_all escapes callbacks and validations
    cards.update_all(order_item_id: oi.id, active: false)
    oi.reload
    if oi.cards.size == oi.quantity
      oi.set_to_delivered!
    elsif oi.cards.any?
      oi.set_to_partial_delivery!
    else
      oi.set_to_failed_delivery!
    end
    
  end

  def is_available?
    active
  end

  private
  def add_stock_to_item
    item.add_to_stock(1)
  end

  def remove_stock_from_item
    item.eleminate_quantity(1)
  end

  def item_is_visible
    return unless item
    errors.add(:item, I18n.t('errors.card.item_not_visible')) unless item.visible
  end

  def item_is_card
    return unless item
    errors.add(:item, I18n.t('errors.card.item_not_card')) unless item.is_card?
  end

  def card_is_active
    throw(:abort) unless active
  end
  
end
