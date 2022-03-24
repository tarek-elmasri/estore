module ErrorHandler
  module Base

    def self.included klazz
      klazz.class_eval do
        rescue_from User::Unauthorized, with: :respond_forbidden
      end

    end
  end
end