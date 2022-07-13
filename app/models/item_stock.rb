class ItemStock < ApplicationRecord
  belongs_to :item

  validates :active, :pending, :sales, :low_stock, numericality: {only_integer: true}

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
      raise StandardError.new('no stock available in pending ') if pending < amount
      self.active = active + amount
      self.pending = pending - amount
      save!
    end
  end

  def sell! amount
    with_lock do
      if has_limited_stock
        raise StandardError.new('no stock available in pending ') if pending < amount
        self.pending = pending - amount
      end
      self.sales = sales + amount
      save!
    end
  end

  def add_to_stock! amount
    return unless has_limited_stock
    with_lock do
      active # hack to perform lock
      self.increment!(:active, amount)
    end
  end

  def remove_from_stock! amount
    return unless has_limited_stock
    with_lock do
      raise StandardError.new('exceeds available stock') if active < amount
      active #hack to perform lock
      decrement!(:active, amount)
    end
  end

end
