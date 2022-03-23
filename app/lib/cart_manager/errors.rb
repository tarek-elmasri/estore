module CartManager
  module Errors
    class ItemNotFound < StandardError; end
    class CartItemNotFound < StandardError; end
    class NoStock < StandardError; end
    class DuplicateNotAllowed < StandardError; end
    class MultipleQuantityNotAllowed < StandardError; end
    class InvalidZeroQuantity < StandardError; end
  end
end
