require 'app_exceptions/custom_errors'
class TokensCore
  attr_accessor :model

  def initialize model
    self.model = model
  end

  protected
  def generate_payload fields
    raise CustomErrors.new("TokensCore generate payload error.\
            unintialized model.") if model.nil?

    payload= {}
    fields ||= []
    fields.each do |field|
      raise CustomErrors.new "TokenCore generate payload \
          error: undefined method #{field} for model #{model}." unless model.methods.include?(field)

        payload[field] = model.send("#{field}")
    end
    payload
  end
end
