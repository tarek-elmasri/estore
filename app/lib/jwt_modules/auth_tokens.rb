require "jwt_modules/jwt_handler"
require "jwt_modules/access_token"
require "jwt_modules/refresh_token"

module JWT_Handler
  module AuthTokens # to includ active record model must have refresh_token field
    extend ActiveSupport::Concern

    attr_accessor :refresh_token_fields, :access_token_fields 
    
    class_methods do
      def has_refresh_token_fields *args
        after_initialize {
          self.refresh_token_fields = args
        }
        before_create {self.refresh_token = self.generate_refresh_token}
        after_create { self.reset_refresh_token if self.refresh_token_fields.include?(:id) }
      end

      def has_access_token_fields *args
        after_initialize {
          self.access_token_fields = args
        }
      end
    end

    def generate_access_token
      AccessToken.new(self).generate_access_token
    end

    def reset_refresh_token
      update_attribute :refresh_token , generate_refresh_token
    end

    def generate_refresh_token
      RefreshToken.new(self).generate_refresh_token
    end

  end
end