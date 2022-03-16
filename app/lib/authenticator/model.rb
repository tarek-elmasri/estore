module Authenticator
  module Model
    extend ActiveSupport::Concern

    included do
      include JwtHandler::AuthTokens
      has_refresh_token_fields :id, :rule
      has_access_token_fields :id, :rule
      has_secure_password
      has_secure_token :forget_password_token

      after_create :create_session

      def self.auth credentials
        return if credentials[:phone_no].blank? || credentials[:password].blank?
        
        user = find_by(phone_no: credentials[:phone_no])
              &.authenticate credentials[:password]
    
        user.create_session if user
        return user
      end

      def self.find_by_password_token token
        find_by(forget_password_token: token)
      end

      def self.find_by_email email
        find_by(email: email)
      end

      def blocked?
        status == "blocked"
      end
    
      def active?
        status == "active"
      end
      
      
      def create_session
        Session.create_or_update id
      end

      
      def kill_current_session
        Session.kill_by_user_id(id)
      end
    end
  end
end