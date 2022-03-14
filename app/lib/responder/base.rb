module Responder
  module Base 
    def unauthorized code="AU401"
      render json: {code: code},status: :unauthorized
    end

    def invalid_token 
      unauthorized "AU410"
    end

    def expired_token
      unauthorized "Au411"
    end

    def respond payload
      render json: payload,status: :ok
    end

    def un_processable payload=nil
      render json: payload,status: :unprocessable_entity
    end
  end
end
    