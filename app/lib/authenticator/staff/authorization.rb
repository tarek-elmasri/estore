module Authenticator
  module Staff
    module Authorization
      extend ActiveSupport::Concern
      

      DEFUALT_RULES = ["admin", "staff" , "user"]

      included do
        has_one :authorization

        validates :rule, inclusion: {in: DEFUALT_RULES}
        
        Authenticator::Staff::AuthorizationTypes::TYPES.each do |action|
          define_method "is_authorized_to_#{action}?" do
            return true if is_admin?
            return false unless is_staff? || is_admin?
            return false unless authorization
            authorization.send(action)
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