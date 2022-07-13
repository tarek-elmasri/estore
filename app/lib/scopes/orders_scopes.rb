module Scopes::OrdersScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      apply_common_scopes only: options[:only], except: options[:except]
      has_scope :only_cards, type: :boolean , as: :cards, only: [:index]
      has_scope :delivered, type: :boolean, only: [:index]
      has_scope :pending_delivery, type: :boolean, only: [:index]
      has_scope :failed_delivery, type: :boolean, only: [:index]
      
    end
  end

end

