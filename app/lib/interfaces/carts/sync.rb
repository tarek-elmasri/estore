class Interfaces::Carts::Sync 

  attr_reader :cart

  def initialize cart
    self.cart=cart
  end


  def sync mem_cart=[]
    mem_cart.each do |new_ci|
      existed_ci = cart.cart_items.find_by(item_id: new_ci[:item_id])
      if existed_ci
        existed_ci.item.duplicate_allowed? ?
          create_ci(new_ci) : update_ci(existed_ci,new_ci)
      else
        create_ci(new_ci)
      end
    end

  end

  private 
  attr_writer :cart

  def update_ci(old_ci,new_ci)
    begin
      CartItem::CartItemUpdate.new(old_ci).update!(quantity: new_ci[:quantity])
    rescue => exception
      nil
    end
    #old_ci.update(quantity: new_ci.quantity)
  end

  def create_ci ci
    begin
      ci[:cart_id] = self.cart.id
      CartItem::CartItemCreation.new(cart,ci).create!
    rescue => exception
      nil
    end
    #self.cart.cart_items.build(ci).save
  end
  
  
  
end