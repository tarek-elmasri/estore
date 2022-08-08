module Scopes::Dashboard::OrdersScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      accepted_options = {only: options.dig(:only), except: options.dig(:except)}
      apply_common_scopes **accepted_options
      has_scope :only_cards, type: :boolean , as: :cards, **accepted_options
      has_scope :delivered, type: :boolean, **accepted_options
      has_scope :pending_delivery, type: :boolean, **accepted_options
      has_scope :failed_delivery, type: :boolean, **accepted_options
      has_scope :by_user_phone_no, as: :user_hpne_no, **accepted_options
      has_scope :by_user_id, as: :user_id, **accepted_options    
    end
  end

end