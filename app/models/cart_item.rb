class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  #new section
  #-----------------------
  #validates :item, presence: true
  validate :zero_quantity , :multi_quantity , :duplicates, :available_item?, :available_quantity?
  #validate :required_quantity

  # def available?
  #   return true if (item && item.visible)
  #   false
  # end

  scope :include_item , -> {includes(:item)}
  scope :only_cards, -> {includes(:item).where(item: {type_name: 'card'})}

  def available_quantity?
    return unless item
    total_quantity = CartItem.where(cart_id: cart_id, item_id: item_id)
                              .sum(:quantity)
    return true if item.has_stock?(total_quantity)
    errors.add(:quantity, I18n.t('errors.cart_items.no_stock'))
    return false
  end

  def available_item?
    return unless item
    return true if item.is_available?
    errors.add(:item , I18n.t('errors.cart_items.not_available'))
    return false
  end

  private
  def zero_quantity
    if quantity < 1
      errors.add(:quantity, I18n.t('errors.cart_items.invalid_quantity'))
    end
  end

  def multi_quantity
    return unless item
    unless item.multi_quantity_allowed?
      errors.add(:quantity, I18n.t('errors.cart_items.multiple_quantity')) if quantity > 1
    end
  end

  def duplicates
    return unless item
    target_item = CartItem.where.not(id: id).find_by(cart_id: cart_id , item_id: item_id)
    unless item.duplicate_allowed?
      errors.add(:item, I18n.t(errors.cart_items.duplicate)) if target_item
    end
  end

  # def required_quantity
  #   total_quantity = quantity
  #   total_quantity += CartItem.where(cart_id: cart_id, item_id: item_id)
  #                             .sum(:quantity) if item.duplicate_allowed?
    
  #   errors.add(:quantity, I18n.t('errors.cart_items.no_stock')) unless available_quantity?(total_quantity)
  # end


end
