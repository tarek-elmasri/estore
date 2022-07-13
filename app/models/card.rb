class Card < ApplicationRecord
  include Interfaces::Cards

  belongs_to :order_item, optional: true
  belongs_to :item

  validates :order_item, presence: true, if: :order_item_id
  validates :code, presence: true
  validate :item_is_visible, :item_is_card

  scope :available, -> {where(active: true, order_item_id: nil).order(created_at: :asc)}

  def is_available?
    active
  end

  private

  def item_is_visible
    return unless item
    errors.add(:item, I18n.t('errors.card.item_not_visible')) unless item.visible
  end

  def item_is_card
    return unless item
    errors.add(:item, I18n.t('errors.card.item_not_card')) unless item.is_card?
  end
 
end
