module Errors

  module ErrorHandler
    module Base

      def self.included klazz
        klazz.class_eval do
          #include Errors::ErrorHandler::CartManagerErrorHandler
          include Errors::ErrorHandler::StripeErrorsHandler
          
          rescue_from JWT::DecodeError, with: :respond_invalid_token
          rescue_from JWT::ExpiredSignature, with: :respond_expired_token

          rescue_from Errors::Unauthorized, with: :respond_forbidden

          rescue_from ActiveRecord::RecordNotFound, with: :respond_not_found 
          rescue_from ActiveRecord::RecordInvalid, with: :record_invalid 
          rescue_from ActiveRecord::RecordNotDestroyed, with: :record_invalid

          rescue_from ActionController::ParameterMissing, with: :respond_bad_request
          rescue_from ActionDispatch::Http::Parameters::ParseError, with: :respond_bad_request
          
          rescue_from Errors::BlockedUser,
                      Errors::ItemHasCardsError, with: :respond_error
        end

      end

      
    end
  end
end