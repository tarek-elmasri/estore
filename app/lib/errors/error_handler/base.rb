module Errors
  module ErrorHandler
    module Base

      def self.included klazz
        klazz.class_eval do
          rescue_from JWT::ExpiredSignature, with: :respond_expired_token
          rescue_from JWT::DecodeError, with: :respond_invalid_token

          rescue_from User::Unauthorized, with: :respond_forbidden
          
          rescue_from ActiveRecord::RecordNotFound, with: :respond_not_found 
          rescue_from Errors::BlockedUser, with: :respond_error
        end

      end

      def respond_error e
        render json: {
          error: I18n.t(e.error),
          code: e.code
        }, status: e.status
      end


    end
  end
end