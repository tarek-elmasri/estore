module StripeManager
  module Base
    class StripeIntent
      attr_reader :status, :client_secret, :intent_object, :id

      def pay(amount,payment_method_id)
        self.intent_object = Stripe::PaymentIntent.create(
          payment_method: payment_method_id,
          amount: amount,
          currency: 'usd',
          confirmation_method: 'manual',
          confirm: true
        )
        self.id = self.intent_object.id
        self.client_secret = self.intent_object.client_secret
        self.status = self.intent_object.status
        return self
      end

      def confirm(payment_intent_id)
        self.intent_object = Stripe::PaymentIntent.confirm(payment_intent_id)
        self.status= self.intent_object.status
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
      attr_writer :status, :client_secret, :intent_object, :id

    end
  end
end