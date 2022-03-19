module Authenticator
  module Staff
    module AuthorizationTypes
      TYPES= [
        :update_authorization,
        :block_user,
        :create_item,
        :update_item,
        :delete_item,
        :create_category,
        :update_category,
        :show_users
      ]

      attr_accessor *TYPES
    end
  end
end
