module Authenticator
  module Staff
    module Authorization
      extend ActiveSupport::Concern

      AUTHORIZATION_TYPES= [
        :create_authorization,
        :update_authorization,
        :delete_authorization,
        :create_item,
        :update_item,
        :delete_item,
        :create_category,
        :update_category,
        
      ]

      included do
        has_many :authorizations

        AUTHORIZATION_TYPES.each do |action|
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