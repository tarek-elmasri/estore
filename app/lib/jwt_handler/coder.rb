
module JwtHandler
  module Coder
    JWT_ACCESS_SECRET_KEY =  Rails.application.credentials.dig(:jwt , :access_secret_key)
    JWT_REFRESH_SECRET_KEY =  Rails.application.credentials.dig(:jwt , :refresh_secret_key)

    def self.encode data={}
      payload = data[:payload] || {}
      payload[:exp] = data.dig(:expires_in)&.to_i || 1.hour.from_now.to_i

      headers = self.config.dig(:headers) || {}

      JWT.encode(
        payload , 
        data[:type]==:access_token ? JWT_ACCESS_SECRET_KEY : JWT_REFRESH_SECRET_KEY, 
        'HS256', 
        headers
      )
    end

    def self.decode(token , type)
      JWT.decode(
        token , 
        type==:access_token ? JWT_ACCESS_SECRET_KEY : JWT_REFRESH_SECRET_KEY,  
        true , 
        { algorithm: 'HS256' }
      )
    end

    def self.config
      data = {}
      config_file = File.join(Rails.root, 'config', 'jwt_handler.yml')
      YAML.load(File.open(config_file)).each do |key, value|
        data[key.to_sym] = value
      end if File.exists?(config_file)
      # symbolize headers keys
      data[:headers] = data[:headers].symbolize_keys if data[:headers]
      data
    end

  end
end