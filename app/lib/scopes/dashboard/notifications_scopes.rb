module Scopes::Dashboard::NotificationsScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      accepted_options = {only: options.dig(:only), except: options.dig(:except)}
      apply_common_scopes **accepted_options
      has_scope :seen, type: :boolean , **accepted_options
      has_scope :unseen, type: :boolean , **accepted_options
      has_scope :of_msg_type, as: :msg_type, **accepted_options
    end
  end

end