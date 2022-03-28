module Errors
  module ErrorHandler
    module CartManagerErrorHandler
      def self.included klazz
        klazz.class_eval do
          rescue_from Errors::CartManager::ZeroQuantityError,
                      Errors::CartManager::MultipleQuantityError,
                      Errors::CartManager::DuplicateError,
                      Errors::CartManager::StockError , with: :respond_error
        end
      end
    end
  end
end