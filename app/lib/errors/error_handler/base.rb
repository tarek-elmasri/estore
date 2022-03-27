module Errors

  module ErrorHandler
    module Base

      def self.included klazz
        klazz.class_eval do
          rescue_from JWT::ExpiredSignature, with: :respond_expired_token
          rescue_from JWT::DecodeError, with: :respond_invalid_token

          rescue_from Errors::Unauthorized, with: :respond_forbidden

          rescue_from ActiveRecord::RecordNotFound, with: :respond_not_found 
          rescue_from ActiveRecord::RecordInvalid, with: :record_invalid 
          rescue_from ActiveRecord::RecordNotDestroyed, with: :record_invalid

          rescue_from ActionController::ParameterMissing, with: :respond_bad_request

          rescue_from Errors::BlockedUser, with: :respond_error
        end

      end

      def record_invalid e
        respond_unprocessable(e.record.errors)
      end

      def respond_error e
        render json: {
          error: I18n.t(e.error),
          code: e.code
        }, status: e.status
      end


      def respond_bad_request e
        render json: {
          error: e.message,
          code: "BD400",
        }, status: 400
      end
    end
  end
end