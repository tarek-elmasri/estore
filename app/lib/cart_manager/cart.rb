# module CartManager
#   module Cart
#     extend ActiveSupport::Concern

#     included do
#       attr_reader :sync_errors

#       def sync(new_cart_iems=[])
#         self.sync_errors = []
#         new_cart_iems.each do |cart_item|
#           begin
#             ci=CartItem.new(cart_item)
#             i= Item.visible.find(ci.item_id)
#             add_item(i,ci.quantity)
#           rescue => e
#             self.sync_errors.push({"#{ci.item_id}": e})
#           end
#         end
#         self.sync_errors = nil unless sync_errors.length > 0
#         return self
#       end
  
#       def add_item item, quantity
#         # item = Item.visible.find(cart_item.item_id)
#         ci= cart_items.build(quantity: quantity, item:item)
#         run_checkers(item , quantity)
        
#         ci.save!
#         ci
#       end
  
#       def remove_item cart_item
#         # ci= cart_items.find(cart_item_id)
#         cart_item.destroy!
#       end
  
#       def update_quantity cart_item , new_quantity
#         # ci = cart_items.find(cart_item.id)
#         cart_item.quantity= new_quantity
#         run_checkers(cart_item.item , cart_item.quantity, cart_item.id)
#         cart_item.update!(quantity: new_quantity)
#       end
  
  
      
#       def add_offer_item cart_offer_item
        
#       end
      
      
#       private 
#       attr_writer :sync_errors
#       def run_checkers( item, required_quantity, exclude_cart_item_id=nil)
#         # cart item id is to exclude it on update quantity feature
#         # when checking quantities and duplicates
#         check_quantity(required_quantity)
#         check_multiple_quantity(required_quantity) unless item.allow_multi_quantity
#         check_duplicate(item, exclude_cart_item_id) unless item.allow_duplicate
#         check_stock(item, required_quantity) if item.has_limited_stock
#         check_customer_maximum_quantity(item,required_quantity, exclude_cart_item_id) if item.limited_quantity_per_customer
  
#       end
  
#       def check_quantity quantity
#         raise Errors::CartManager::ZeroQuantityError unless quantity && quantity > 0
#       end
  
#       def check_duplicate( item, exclude_cart_item_id)
#         target_item = CartItem.where.not(id: exclude_cart_item_id).find_by(cart_id: id , item_id: item.id)
#         raise Errors::CartManager::DuplicateError if target_item
#       end
      
#       def check_stock(item, required_quantity)
#         raise Errors::CartManager::StockError unless item.has_stock?(required_quantity)
#       end
  
#       def check_multiple_quantity quantity
#         raise Errors::CartManager::MultipleQuantityError if quantity > 1
#       end
  
#       def check_customer_maximum_quantity(item, required_quantity, exclude_cart_item_id)
#         # checking customer orders and cart items for item id and
#         # compare required quantity with item maximum quantity
#       end



#     end

#   end
# end