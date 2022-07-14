module Scopes::Dashboard::CardsScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      accepted_options = {only: options.dig(:only), except: options.dig(:except)}
      apply_common_scopes **accepted_options
      
    end
  end

end