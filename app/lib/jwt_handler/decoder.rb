
module JwtHandler
  class Decoder

    attr_reader :token
    attr_reader :payload
    attr_reader :headers
    attr_reader :type

    def initialize token,type
      self.token=token
      self.type=type
      decode
    end

    def valid?
      return false if payload.blank? || headers.blank?

      default_headers = JwtHandler::Coder.config.dig(:headers)
      default_headers.map do |k,v|
        return false unless headers[k] == v
      end if default_headers

      true
    end

    private 
    attr_writer :token
    attr_writer :payload
    attr_writer :headers
    attr_writer :type

    def decode

      data = JwtHandler::Coder.decode token,type
      self.payload = data.first.symbolize_keys
      self.headers = data.last.symbolize_keys
    
      raise JWT::DecodeError.new "unmatched headers" unless valid?
    end
  end
end