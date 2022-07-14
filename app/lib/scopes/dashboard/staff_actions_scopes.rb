module Scopes::Dashboard::StaffActionsScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      accepted_options = {only: options.dig(:only), except: options.dig(:except)}
      apply_common_scopes **accepted_options
      has_scope :action_type, **accepted_options
      has_scope :model_type_name, as: :model_name, **accepted_options
      has_scope :of_model_id, as: :model_id, **accepted_options
      has_scope :by_user_id, **accepted_options
    end
  end

end