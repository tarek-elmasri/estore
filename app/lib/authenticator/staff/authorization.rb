module Authenticator
  module Staff
    module Authorization
      extend ActiveSupport::Concern
      

      DEFAULT_RULES = ["admin", "staff" , "user"]

      included do
        has_one :authorization

        validates :rule, inclusion: {in: DEFAULT_RULES, message: I18n.t("errors.authorization.invalid_rule")}

        #before_update :check_authorization
        #after_update :check_rule

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

        def is_user?
          rule == 'user'
        end

        private
        # def check_authorization
        #   if self.rule_changed?
        #     raise Errors::Unauthorized unless Current.user.is_authorized_to_update_authorization?
        #     raise Errors::Unauthorized if self.rule == "admin" && Current.user.rule == "staff"
        #   end
        # end

        # def check_rule
        #   if self.rule == 'user' || self.rule == 'admin'
        #     self.authorization&.destroy
        #   end
        # end
      end

    end
  end
end