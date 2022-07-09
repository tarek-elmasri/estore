class Interfaces::Carts::Checkout

  attr_reader :cart

  def initialize cart
    self.cart = cart
  end

  def checkout
    Cart.transaction do
      cart.checkout_errors={}
      cart.checkout_errors['items'] = [I18n.t("errors.cart.empty")] if cart.cart_items.empty?
      cart.cart_items.each do |ci|
        begin
          if ci.valid? # && ci.available_quantity?
            #raise StandardError
            Item::ItemStocker.new(ci.item).reserve_stock!(ci.quantity)
          else
            cart.checkout_errors["#{ci.id}"] = ci.errors 
          end
        rescue => exception
          cart.checkout_errors["#{ci.id}"] = {quantity: [I18n.t('errors.cart_items.no_stock')]}
        end
      end
      cart.checkout_errors = nil unless cart.checkout_errors.length > 0
      raise StandardError.new('checkout errors is here') if cart.checkout_errors
    end

    # return false if self.checkout_errors
    # true
  end

  private
  attr_writer :cart

end