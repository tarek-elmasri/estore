module CartManager
  

  class Cart
    
    attr_reader :errors

    def initialize user
      self.user=user
      self.cart = user.cart
    end

    def sync(cart_iems=[])
      self.errors = []
      cart_iems.each do |cart_item|
        begin
          add_item(cart_item)
        rescue 
          self.error.push({"#{cart_item.item_id}": "error"})
        end
      end
      self.errors = nil unless self.errors.length > 0
      return self.cart
    end

    def add_item cart_item
      item = Item.visible.find_by(id: cart_item.item_id)
      raise CartManager::Errors::ItemNotFound unless item

      check_stock(item, cart_item.quantity) if item.has_limited_stock
      check_multiple_quantity(cart_item.quantity) unless item.allow_multi_quantity
      check_duplicate(item) unless item.allow_duplicate
      check_customer_maximum_quantity(item, cart_item.quantity) if item.limited_quantity_per_customer

      self.cart.cart_items.create(item_id: item.id)
    end
    
    def add_offer_item cart_offer_item
      
    end
    
    
    private 
    attr_accessor :cart
    attr_writer :errors
    attr_accessor :user

    def check_duplicate item
      target_item = CartItem.find_by(cart_id: self.cart.id , item_id: item.id)
      raise CartManager::Errors::DuplicateNotAllowed if target_item
    end
    
    def check_stock(item, required_quantity)
      raise CartManager::Errors::NoStock unless item.has_stock?(required_quantity)
    end

    def check_multiple_quantity quantity
      raise CartManager::Errors::MultipleQuantityNotAllowed if quantity > 1
    end

    def check_customer_maximum_quantity(item, required_quantity)
      # checking customer orders for item id and
      # compare required quantity with item maximum quantity
    end
    

    

  end

end