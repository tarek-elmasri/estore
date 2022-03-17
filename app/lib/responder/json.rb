module Responder
  module Json
      
    def respond_unauthorized(code="UA401", message="errors.authorization.unauthorized")
      render json: {code: code, message: I18n.t(message)},status: :unauthorized
    end

    def respond_invalid_token 
      respond_unauthorized("UA410","errors.authorization.invalid_token")
    end

    def respond_expired_token
      respond_unauthorized("UA411","errors.authorization.expired_token")
    end

    def respond_invalid_password_token
      respond_unauthorized("UA413","errors.authorization.invalid_password_token")
    end

    def respond payload, includes=[]
      render json: payload
    end

    def respond_ok
      render json: {message: :ok}
    end

    def respond_with_access_token(user)
      render json: {access_token: user.generate_access_token}
    end

    def respond_with_user_data user
      return respond_unauthorized if user.blank?
      return respond_blocked_user if user.blocked?
      respond({tokens: user.tokens , user:user})
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
      respond_unauthorized("UA412","errors.authorization.blocked_user")
    end
  end
end

    