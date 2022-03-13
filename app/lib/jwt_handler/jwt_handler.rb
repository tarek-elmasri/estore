
module JwtHandler

  JWT_SECRET_KEY =  Rails.application.credentials.dig(:jwt , :secret_key)

  def self.encode (data={})
    payload = data[:payload] || {}
    payload[:exp] = data.dig(:expires_in)&.to_i
    payload[:iss] = self.config.dig(:iss)

    headers = self.config.dig(:headers)
    if data[:headers].present?
      data[:headers].map {|k,v| headers[k] = v}
    end

    token = JWT.encode(payload , JWT_SECRET_KEY, 'HS256', headers)
  end

  def self.decode token 
    JWT.decode token , JWT_SECRET_KEY , true , { algorithm: 'HS256' }
  end

  def self.config
    data = {}
    config_file = File.join(Rails.root, 'config', 'jwt_handler.yml')
    YAML.load(File.open(config_file)).each do |key, value|
      data[key.to_s] = value
    end if File.exists?(config_file)

    data
  end

end