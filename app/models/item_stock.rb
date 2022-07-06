class ItemStock < ApplicationRecord
  belongs_to :item

  def has_active_stock? amount
    return true unless has_limited_stock
    return active_stock >= amount
  end

  def active_stock
    active
  end

  def move_to_pending!(amount)
    return unless has_limited_stock
    with_lock do
      raise StandardError.new('no stock available') if active < amount
      self.active = active - amount
      self.pending = pending + amount
      save!
    end
  end

  def release_from_pending!(amount)
    return unless has_limited_stock
    with_lock do
      self.active = active + amount
      self.pending = pending - amount
      save!
    end
  end

  def sell! amount
    with_lock do
      if has_limited_stock
        self.pending = pending - amount
      end
      self.sales = sales + amount
      save!
    end
  end

end
