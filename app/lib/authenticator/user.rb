module Authenticator
  module User
    extend ActiveSupport::Concern

    included do
      include JwtHandler::AuthTokens
      has_one :session
      has_refresh_token_fields :id, :rule
      has_access_token_fields :id, :rule
      has_secure_password
      has_secure_token :forget_password_token

      after_create :create_session

      def self.auth credentials
        raise ActiveRecord::RecordNotFound if credentials[:phone_no].blank? || credentials[:password].blank?
        
        user = find_by(phone_no: credentials[:phone_no])
              &.authenticate credentials[:password]
    
        raise ActiveRecord::RecordNotFound unless user
        raise Errors::BlockedUser if user.blocked?
        user.create_session
        return user
      end

      # def self.find_by_password_token token
      #   return unless token
      #   find_by(forget_password_token: token)
      # end

      def self.request_forget_password_token_by_email user_email
        return unless user_email
        user = User.find_by_email(user_email)
        if user
          raise Errors::BlockedUser if user.blocked?
          # send email with params[:reset_link] with token=user.forget_password_token
          #set job to regenerate forget password token after 10 mins to de validate token
        end
      end

      def self.find_by_password_token! pass_token
        raise ActiveRecord::RecordNotFound unless pass_token
        User.find_by!(forget_password_token: pass_token)
      end

      def reset_password new_pass
        self.password= new_pass
        self.should_validate_password = true
        self.save!
        self.kill_current_session
        self.create_session
        self.reset_refresh_token
        self.regenerate_forget_password_token
        # TODO: send email successsfull password change
        
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
      
      
      def create_session
        Session.create_or_update id
      end

      
      def kill_current_session
        Session.kill_by_user_id(id)
      end
    end
  end
end