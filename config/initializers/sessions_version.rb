
#APP_VERSION = JwtHandler::Coder.config.dig(:headers,:version) || ENV['APP_VERSION']

# jwt_config_file = File.join(Rails.root, 'config', 'jwt_handler.yml')
# jwt_config = {}
# YAML.load(File.open(jwt_config_file)).each do |key, value|
#   jwt_config[key.to_s] = value
# end if File.exists?(jwt_config_file)
# APP_VERSION = jwt_config['headers']['version'] || ENV['APP_VERSION']