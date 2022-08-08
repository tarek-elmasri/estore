module Authenticator
  module User
    extend ActiveSupport::Concern

    included do
      include JwtHandler::AuthTokens
      has_refresh_token_fields :id, :rule
      has_access_token_fields :id, :rule
      has_secure_password
      has_secure_token :forget_password_token

      def self.find_by_password_token! pass_token
        raise ActiveRecord::RecordNotFound unless pass_token
        user= find_by!(forget_password_token: pass_token)
        raise Errors::BlockedUser if user.blocked?
        user
      end

      def find_by_refresh_token! token
        raise ActiveRecord::RecordNotFound unless token
        user= find_by!(refresh_token: token)
        raise Errors::BlockedUser if user.blocked?
        user
      end

      def self.find_by_email email
        return unless email
        user= find_by(email: email)
        raise Errors::BlockedUser if user.blocked?
        user
      end

      def blocked?
        status == "blocked"
      end
    
      def active?
        status == "active"
      end

    end
  end
end