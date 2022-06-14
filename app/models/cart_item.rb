class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  #new section
  #-----------------------
  validates :item, presence: true
  validate :zero_quantity , :multi_quantity, :duplicates, :required_quantity

  def available?
    return true if (item && item.visible)
    false
  end

  def available_quantity?(required_quantity=quantity)
    item.has_stock?(required_quantity)
  end

  private
  def zero_quantity
    if quantity < 1
      errors.add(:quantity, I18n.t('errors.cart_items.invalid_quantity'))
    end
  end

  def multi_quantity
    unless item.multi_quantity_allowed?
      errors.add(:quantity, I18n.t('errors.cart_items.multiple_quantity')) if quantity > 1
    end
  end

  def duplicates
    target_item = CartItem.where.not(id: id).find_by(cart_id: cart_id , item_id: item_id)
    unless item.duplicate_allowed?
      errors.add(:item, I18n.t(errors.cart_items.duplicate)) if target_item
    end
  end

  def required_quantity
    total_quantity = quantity
    total_quantity += CartItem.where(cart_id: cart_id, item_id: item_id)
                              .sum(:quantity) if item.duplicate_allowed?
    
    errors.add(:quantity, I18n.t('errors.cart_items.no_stock')) unless available_quantity?(total_quantity)
  end

  
end
