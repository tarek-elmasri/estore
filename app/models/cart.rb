class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  has_many :items , through: :cart_items

  attr_reader :checkout_errors

  def sync mem_cart=[]
    mem_cart.each do |mem_ci|
      new_ci= CartItem.new(mem_ci)
      existed_ci = cart_items.find_by(item_id: new_ci.item_id)
      if existed_ci
        existed_ci.item.duplicate_allowed? ?
          create_ci(new_ci) : update_ci(existed_ci,new_ci)
      else
        create_ci(new_ci)
      end
    end

  end

  def valid_for_checkout? 
    self.checkout_errors={}
    cart_items.each do |ci|
      unless ci.valid? && ci.available_quantity?
        self.checkout_errors["#{ci.id}"] = ci.errors
      end
    end
    self.checkout_errors = nil unless self.checkout_errors.length > 0
    return false if self.checkout_errors
    return true
  end

  private 
  attr_writer :checkout_errors

  def update_ci(old_ci,new_ci)
    old_ci.update(quantity: new_ci.quantity)
  end

  def create_ci ci
    cart_items.build(ci).save
  end



end
