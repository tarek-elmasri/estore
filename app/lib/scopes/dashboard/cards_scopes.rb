module Scopes::Dashboard::CardsScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      apply_common_scopes only: options[:only], except: options[:except]
      
    end
  end

end