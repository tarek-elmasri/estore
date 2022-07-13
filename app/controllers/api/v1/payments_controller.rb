class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user
  before_action :set_order

  def create
    intent = Order::StripeIntent.new(@order)
    intent.pay(params.require(:payment_method_id))

    return handle_response(intent)
  end


  def update
    intent = Order::StripeIntent.new(@order)
                                .confirm
    return handle_response(intent)
  end

  private
  def set_order
    @order= Current.user.orders.not_fullfilled.find(params.require(:order_id)) 
  end

  def handle_response(intent)

    if intent.payment_require_auth?
      return respond({
        requires_action: true,
        payment_intent_client_secret: intent.client_secret
        })
    elsif intent.payment_succeed?
      Cart::Clear.new(Current.user.cart).clear!
      return respond({success: true})
    else
      return respond_unprocessable({errors: "invalid status"})
    end
  end


private
def update_order_status intent
  Order::OrderUpdate.new(@order)
                    .update_payment_status!(intent.id, intent.status)
end

end