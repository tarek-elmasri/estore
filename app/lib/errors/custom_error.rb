class Errors::CustomError < StandardError

  attr_accessor :code , :status , :error
  def initialize(error , code , status)
    self.error=error
    self.code = code
    self.status = status
  end

end