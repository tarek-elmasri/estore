class Interfaces::Orders::OrderCreation

  attr_accessor :cart
  attr_accessor :user
  attr_reader :order
  attr_reader :checkout_errors

  def initialize cart , user
    self.cart= cart
    self.user=user
    self.order=Order.new
  end

  def create!
    Order.transaction do
      build_order_values
      proceed_checkout
      order.save!
      create_order_items
      create_cleanup_job
    end
    return order
  end


  private
  attr_writer :checkout_errors
  attr_writer :order

  def build_order_values
    order.user_id = user.id

    order.t_value = 0.00
    #TODO implement vat mechanism
    order.t_vat = 0.00
    cart.cart_items.each do |ci|
      order.t_value += (ci.item.has_discount ? ci.item.discount_price : ci.item.price) * ci.quantity
    end

    order.t_payment= order.t_value + order.t_vat
  end


  def proceed_checkout
    begin
      Cart::Checkout.new(cart).checkout
      #cart.checkout
    rescue => exception
      order.errors.add(:cart, cart.checkout_errors)
    end

    raise ActiveRecord::RecordInvalid.new(order) unless order.errors.empty?
  end

  def create_order_items
    order_items_array =[]
    cart.cart_items.include_item.each do |ci|
      oi= {
        order_id: order.id,
        quantity: ci.quantity,
        value: ci.item.has_discount ? ci.item.discount_price : ci.item.price,
        description: ci.item.name,
        item_id: ci.item_id,
        type_name: ci.item.type_name
      }
      oi[:t_value] = oi[:quantity] * oi[:value]
      order_items_array.push(oi)
    end

    OrderItem.create!(order_items_array)
  end

  def create_cleanup_job
    OrderCleanupJob.set(wait: 5.minutes).perform_later(order.id)
  end

end