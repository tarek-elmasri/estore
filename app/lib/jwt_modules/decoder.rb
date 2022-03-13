
module JWT_Handler
  class Decoder

    attr_reader :token
    attr_reader :payload
    attr_reader :headers
    attr_accessor :options

    def initialize token, options={}
      self.token=token
      self.options=options
      decode
    end

    def valid? custom_options = nil
      return false if payload.blank? || headers.blank?

      if custom_options.present?
        current_options = custom_options
      else
        current_options = options
      end
      
      if current_options[:type].present?
        return false unless current_options[:type] == headers[:type].to_sym
      end


      true
      rescue
        return false
    end

    private 
    attr_writer :token
    attr_writer :payload
    attr_writer :headers

    def decode 
      data = JWT_Handler.decode token
      self.payload = data.first.symbolize_keys
      self.headers = data.last.symbolize_keys
    rescue
      nil
    end
  end
end