
APP_VERSION = JwtHandler::Coder.config.dig(:headers,:version) || ENV['APP_VERSION']