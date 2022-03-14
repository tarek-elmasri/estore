
module JwtHandler
  module AuthTokens # to includ active record model must have refresh_token field
    extend ActiveSupport::Concern

    attr_reader :refresh_token_fields, :access_token_fields
    
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
      JwtHandler::Tokens::AccessToken.new(self).generate_access_token
    end

    def reset_refresh_token
      update_attribute :refresh_token , generate_refresh_token unless new_record?
    end

    def generate_refresh_token
      JwtHandler::Tokens::RefreshToken.new(self).generate_refresh_token
    end 

    private
    attr_writer :refresh_token_fields, :access_token_fields
  end
end