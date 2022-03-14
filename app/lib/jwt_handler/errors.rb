module JwtHandler 
  module Errors
    class UndefinedModel < StandardError; end
    class UnintializedField < StandardError; end
  end
end