module Authenticator
  module Staff
    module Authorization
      extend ActiveSupport::Concern
      include Authenticator::Staff::AuthorizationTypes


      included do
        has_many :authorizations

        TYPES.each do |action|
          define_method "is_authorized_to_#{action}?" do
            return true if is_admin?
            return false unless is_staff? || is_admin?
            authorizations.where(type: action).exists?
          end
        end

        def is_staff?
          rule == "staff"
        end

        def is_admin?
          rule == "admin"
        end

      end
    end
  end
end