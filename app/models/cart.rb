class Cart < ApplicationRecord
  include Interfaces::Carts
  
  belongs_to :user
  has_many :cart_items
  has_many :items , through: :cart_items

  attr_accessor :checkout_errors

  def is_empty?
    cart_items.empty?
  end

end
