class Order < ApplicationRecord
  
  attr_accessor :cart

  belongs_to :user
  has_many :order_items


  validates :cart, presence: true 
  validate :cart_checkout

  before_validation :build_values

  private

  def build_values
    return unless self.cart

    
  end

  def cart_checkout
    return unless self.cart
    unless self.cart.valid_for_checkout?
      errors.add(:cart , self.cart.checkout_errors)
    end
  end



end
