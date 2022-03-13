
class TokensCore
  attr_accessor :model

  def initialize model
    self.model = model
  end

  protected
  def generate_payload fields
    raise JwtHandler::UndefinedModel.new("TokensCore generate payload error.\n
            unintialized model.") if model.nil?

    payload= {}
    fields ||= []
    fields.each do |field|
      raise JwtHandler::UnintializedField.new "TokenCore generate payload \n
          error: undefined method #{field} for model #{model}." unless model.methods.include?(field)

        payload[field] = model.send("#{field}")
    end
    payload
  end
end
