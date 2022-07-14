module Scopes::Dashboard::CategoriesScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      accepted_options = {only: options.dig(:only), except: options.dig(:except)}
      apply_common_scopes **accepted_options
      has_scope :primary, type: :boolean, default: true, **accepted_options
      has_scope :name_like, as: :name, **accepted_options
      has_scope :only_pinned, as: :pinned, type: :boolean, **accepted_options
    end
  end

end