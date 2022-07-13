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

    def respond payload, options={}
      render json: payload, fields: options[:fields], include: options[:include]
    end

    def respond_ok
      render json: {message: :ok}
    end

    def respond_unprocessable( errors={}, code="UP422")
      payload={
        code: code,
        errors: errors
      }
      
      render json: payload,status: :unprocessable_entity
    end

    def respond_not_found
      render json: {
        code: "NF422",
        errors: I18n.t("errors.not_found")
      }, status: :unprocessable_entity
    end

    def record_invalid e
      respond_unprocessable(e.record.errors)
    end

    def respond_error e
      render json: {
        error: I18n.t(e.error),
        code: e.code
      }, status: e.status
    end

    def route_not_found
      render json: {
        error: I18n.t('error.routes.not_found'),
        code: '404'
      }, status: 404
    end


    def respond_bad_request e
      render json: {
        error: e.message,
        code: "BD400",
      }, status: 400
    end

    def respond_forbidden
      render json: {
        code: "NS401",
        message: I18n.t("errors.authorization.staff_only")
      },status: :forbidden
    end
  end
end

    