require "app_exceptions/custom_errors"

module JWT_Handler

  JWT_SECRET_KEY =  Rails.application.credentials.jwt[:secret_key]
  DEFAULT_EXPIRE_TIME=  1.hour.from_now.to_i
  DEFUALT_ISSUER = "SD_API"
  HEADERS=  {type: "JWT"}

  def self.encode (data={})
    payload = data[:payload] || {}
    payload[:exp] = data[:expires_in]&.to_i || DEFAULT_EXPIRE_TIME
    payload[:iss] = DEFUALT_ISSUER

    headers = HEADERS
    if data[:headers].present?
      data[:headers].map {|k,v| headers[k] = v}
    end

    token = JWT.encode(payload , JWT_SECRET_KEY, 'HS256', headers)
  end

  def self.decode token 
    JWT.decode token , JWT_SECRET_KEY , true , { algorithm: 'HS256' }
  end

  

end