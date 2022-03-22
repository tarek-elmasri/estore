module CartManager
  module Errors
    class ItemNotFound < StandardError; end
    class NoStock < StandardError; end
    class DuplicateNotAllowed < StandardError; end
    class MultipleQuantityNotAllowed < StandardError; end
  end
end
