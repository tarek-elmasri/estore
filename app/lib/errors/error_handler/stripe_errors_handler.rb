module Errors
  module ErrorHandler
    module StripeErrorsHandler
      def self.included klazz
        klazz.class_eval do
          rescue_from Stripe::AuthenticationError,
                      Stripe::APIConncectionError,
                      Stripe::APIError,
                      Stripe::InvalidRequestError,
                      Stripe::CardError,
                      Stripe::IdempotencyError, with: :respond_stripe_errors
        end
      end
    end
  end
end