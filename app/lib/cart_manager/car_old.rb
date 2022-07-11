# module CartManager
  

#   class Cart
    
#     attr_reader :errors
#     attr_reader :cart

#     def initialize user
#       self.user=user
#       self.cart = user.cart
#     end

#     def sync(cart_iems=[])
#       self.errors = []
#       cart_iems.each do |cart_item|
#         begin
#           add_item(cart_item)
#         rescue => e
#           self.errors.push({"#{cart_item.item_id}": e})
#         end
#       end
#       self.errors = nil unless self.errors.length > 0
#       return self.cart
#     end

#     def add_item cart_item
#       item = Item.visible.find(cart_item.item_id)
      
#       run_checkers(item , cart_item.quantity)

#       cart_item.cart_id = cart.id
#       cart_item.save!
#       cart_item
#     end

#     def remove_item cart_item_id
#       ci= self.cart.cart_items.find(cart_item_id)
#       ci.destroy!
#     end

#     def update_quantity cart_item_id , new_quantity
#       ci = self.cart.cart_items.find(cart_item_id)

#       run_checkers(ci.item , new_quantity, ci.id)
#       ci.update!(quantity: new_quantity)
#     end


    
#     def add_offer_item cart_offer_item
      
#     end
    
    
#     private 
#     attr_writer :cart
#     attr_writer :errors
#     attr_accessor :user

#     def run_checkers( item, required_quantity, exclude_cart_item_id=nil)
#       # cart item id is to exclude it on update quantity feature
#       # when checking quantities and duplicates
#       check_quantity(required_quantity)
#       check_multiple_quantity(required_quantity) unless item.allow_multi_quantity
#       check_duplicate(item, exclude_cart_item_id) unless item.allow_duplicate
#       check_stock(item, required_quantity) if item.has_limited_stock
#       check_customer_maximum_quantity(item,required_quantity, exclude_cart_item_id) if item.limited_quantity_per_customer

#     end

#     def check_quantity quantity
#       raise Errors::CartManager::ZeroQuantityError unless quantity && quantity > 0
#     end

#     def check_duplicate( item, exclude_cart_item_id)
#       target_item = CartItem.where.not(id: exclude_cart_item_id).find_by(cart_id: self.cart.id , item_id: item.id)
#       raise Errors::CartManager::DuplicateError if target_item
#     end
    
#     def check_stock(item, required_quantity)
#       raise Errors::CartManager::StockError unless item.has_stock?(required_quantity)
#     end

#     def check_multiple_quantity quantity
#       raise Errors::CartManager::MultipleQuantityError if quantity > 1
#     end

#     def check_customer_maximum_quantity(item, required_quantity, exclude_cart_item_id)
#       # checking customer orders and cart items for item id and
#       # compare required quantity with item maximum quantity
#     end
    

    

#   end

# end