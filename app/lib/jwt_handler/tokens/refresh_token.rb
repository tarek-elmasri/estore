
module JwtHandler
  module Tokens
    class RefreshToken < TokensCore

      def initialize(model)
        super(model)
      end

      def generate_refresh_token
        JwtHandler::Coder.encode type: :refresh_token,
                                  payload: generate_payload(model.refresh_token_fields) , 
                                  expires_in: JwtHandler::Coder.config.dig(:refresh_expire_time)&.hours.from_now
      end

            
    end
  end
end