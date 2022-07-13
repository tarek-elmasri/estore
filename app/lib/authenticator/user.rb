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
        find_by!(forget_password_token: pass_token)
      end

      def find_by_refresh_token! token
        raise ActiveRecord::RecordNotFound unless token
        find_by!(refresh_token: token)
      end

      def self.find_by_email email
        return unless email
        find_by(email: email)
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