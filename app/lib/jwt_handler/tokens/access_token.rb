module JwtHandler
  module Tokens
    class AccessToken < TokensCore

      def initialize model
        super(model)
      end
          
      def generate_access_token
        JwtHandler::Coder.encode payload: generate_payload(model.access_token_fields) , 
                            expires_in: JwtHandler::Coder.config.dig(:access_expire_time)&.minutes.from_now
      end
    end
  end
end
