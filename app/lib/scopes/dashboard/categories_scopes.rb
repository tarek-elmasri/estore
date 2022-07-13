module Scopes::Dashboard::CategoriesScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      apply_common_scopes only: options[:only], except: options[:except]
      has_scope :primary, type: :boolean, default: true, only: options[:only], except: options[:except]
      has_scope :name_like, as: :name, only: options[:only], except: options[:except]
      has_scope :only_pinned, as: :pinned, type: :boolean, only: options[:only], except: options[:except]
    end
  end

end