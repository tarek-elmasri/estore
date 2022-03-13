require "jwt_modules/jwt_handler"
require 'jwt_modules/auth_tokens'
require 'jwt_modules/tokens_core'
module JWT_Handler
  module AuthTokens
    class AccessToken < TokensCore

      def initialize model
        super(model)
      end
          
      def generate_access_token
        JWT_Handler.encode payload: generate_payload(model.access_token_fields) , 
                            expires_in: 30.minutes.from_now , 
                            headers: {
                              type: :ACCESS_TOKEN ,
                            }
      end
    end
  end
end
