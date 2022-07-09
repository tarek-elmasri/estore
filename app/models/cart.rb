class Cart < ApplicationRecord
  include Interfaces::Carts
  
  belongs_to :user
  has_many :cart_items
  has_many :items , through: :cart_items

  attr_accessor :checkout_errors

  def is_empty?
    cart_items.empty?
  end

  def clear!
    cart_items.destroy_all
  end

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

  # def valid_for_checkout? 
  #   self.checkout_errors={}
  #   self.checkout_errors['items'] = [I18n.t("errors.cart.empty")] if cart_items.empty?
  #   cart_items.each do |ci|
  #     unless ci.valid? && ci.available_quantity?
  #       self.checkout_errors["#{ci.id}"] = ci.errors
  #     end
  #   end
  #   self.checkout_errors = nil unless self.checkout_errors.length > 0
  #   retpurn false if self.checkout_errors
  #   return true
  # end

  # def checkout
  #   transaction do
  #     self.checkout_errors={}
  #     self.checkout_errors['items'] = [I18n.t("errors.cart.empty")] if cart_items.empty?
  #     cart_items.each do |ci|
  #       begin
  #         if ci.valid? && ci.available_quantity?
  #           #raise StandardError
  #           ci.freeze_quantity!
  #         else
  #           self.checkout_errors["#{ci.id}"] = ci.errors 
  #         end
  #       rescue => exception
  #         self.checkout_errors["#{ci.id}"] = {quantity: [I18n.t('errors.cart_items.no_stock')]}
  #       end
  #     end
  #     self.checkout_errors = nil unless self.checkout_errors.length > 0
  #     raise StandardError if self.checkout_errors
  #   end

  #   # return false if self.checkout_errors
  #   # true
  # end

  # private 
  # attr_writer :checkout_errors

  # def update_ci(old_ci,new_ci)
  #   old_ci.update(quantity: new_ci.quantity)
  # end

  # def create_ci ci
  #   cart_items.build(ci).save
  # end



end
