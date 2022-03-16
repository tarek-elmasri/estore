module Responder
  module Json
      
    def respond_unauthorized(code="UA401", message=:unauthorized)
      render json: {code: code, message: I18n.t(message)},status: :unauthorized
    end

    def respond_invalid_token 
      unauthorized("UA410",:invalid_token)
    end

    def respond_expired_token
      unauthorized("UA411",:expired_token)
    end

    def respond_invalid_password_token
      unauthorized("UA413",:invalid_password_token)
    end

    def respond payload, includes=[]
      render json: payload,status: :ok
    end

    def respond_unprocessable errors={}
      payload={
        code: "UP422",
        errors: errors
      }
      
      render json: payload,status: :unprocessable_entity
    end
    
    def respond_invalid_credentials
      render json: {
        code: "UP444", 
        errors: "invalid credentials"
        },status: :unprocessable_entity
    end

    def respond_blocked_user
      unauthorized("UA412",:blocked_user)
    end
  end
end

    