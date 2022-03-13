require 'jwt_modules/tokens_core'
require 'jwt_modules/auth_tokens'
require 'jwt_modules/jwt_handler'

module JWT_Handler
  module AuthTokens
    class RefreshToken < TokensCore

      def initialize(model)
        super(model)
      end

      def generate_refresh_token
        JWT_Handler.encode payload: generate_payload(model.refresh_token_fields) , 
                            expires_in: 1.year.from_now , 
                            headers: {
                              type: :REFRESH_TOKEN,
                            }
      end

            
    end
  end
end