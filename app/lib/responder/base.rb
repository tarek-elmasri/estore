module Responder
  module Base 
    def unauthorized code="UA401"
      render json: {code: code},status: :unauthorized
    end

    def invalid_token 
      unauthorized "UA410"
    end

    def expired_token
      unauthorized "UA411"
    end

    def respond payload, includes=[]
      render json: payload,status: :ok
    end

    def un_processable errors={}
      payload={
        code: "UP422",
        errors: errors
      }
      
      render json: payload,status: :unprocessable_entity
    end

    def blocked_user
      unauthorized "UA412"
    end
  end
end
    