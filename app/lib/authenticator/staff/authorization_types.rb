module Authenticator
  module Staff
    module AuthorizationTypes
      TYPES= [
        :update_authorization,
        :show_items,
        :create_item,
        :update_item,
        :delete_item,
        :show_cards,
        :create_card,
        :update_card,
        :delete_card,
        :show_categories,
        :create_category,
        :update_category,
        :delete_category,
        :show_users,
        :update_user,
        :update_user_status,
        :show_orders,
        :update_order_item,
      ]

      attr_accessor *TYPES
    end
  end
end
