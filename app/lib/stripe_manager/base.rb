module StripeManager
  module Base
    class StripeIntent
      attr_reader :status, :client_secret, :intent_object, :id, :order

      def initialize order
        self.order= order
      end

      def pay(payment_method_id)
        self.intent_object = Stripe::PaymentIntent.create(
          payment_method: payment_method_id,
          amount: required_payment,
          currency: 'usd',
          confirmation_method: 'manual',
          confirm: true
        )
        self.id = self.intent_object.id
        self.client_secret = self.intent_object.client_secret
        self.status = self.intent_object.status
        update_order_status
        return self
      end

      def confirm
        self.intent_object = Stripe::PaymentIntent.confirm(order.payment_intent)
        self.status= self.intent_object.status
        update_order_status
        return self
      end

      def payment_succeed?
        return false unless self.intent_object
        self.intent_object.status == "succeeded"
      end



      def payment_require_auth?
        return false unless self.intent_object
        self.intent_object.status == 'requires_action' && self.intent_object.next_action.type== 'use_stripe_sdk'
      end

      private 
      attr_writer :status, :client_secret, :intent_object, :id, :order

      def required_payment
        (@order.t_payment * 100).to_s.split(".")[0].to_i
      end

      def update_order_status
        Order::OrderUpdate.new(@order)
                          .update_payment_status!(id, status)
      end
    end
  end
end