module Scopes::Dashboard::StaffActionsScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      apply_common_scopes only: options[:only], except: options[:except]
      has_scope :action_type, only: options[:only], except: options[:except]
      has_scope :model_type_name, as: :model_name, only: options[:only], except: options[:except]
      has_scope :of_model_id, as: :model_id, only: options[:only], except: options[:except]
      has_scope :by_user_id, only: options[:only], except: options[:except]
    end
  end

end