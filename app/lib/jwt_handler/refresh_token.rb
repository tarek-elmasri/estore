
module JwtHandler
  module AuthTokens
    class RefreshToken < TokensCore

      def initialize(model)
        super(model)
      end

      def generate_refresh_token
        JwtHandler.encode payload: generate_payload(model.refresh_token_fields) , 
                          expires_in: 1.year.from_now , 
                          headers: {
                            type: :REFRESH_TOKEN,
                          }
      end

            
    end
  end
end