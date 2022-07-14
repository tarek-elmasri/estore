module Scopes::Dashboard::ItemsScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      accepted_options = {only: options.dig(:only), except: options.dig(:except)}
      apply_common_scopes **accepted_options
      has_scope :name_like, as: :name, **accepted_options
      has_scope :of_category_id, as: :category_id, **accepted_options
      has_scope :only_cards, type: :boolean, as: :cards, **accepted_options
      has_scope :has_discount, type: :boolean, **accepted_options
      has_scope :order_by_best_sales, type: :boolean, **accepted_options
      has_scope :order_by_high_price, type: :boolean, **accepted_options
      has_scope :order_by_low_price, type: :boolean, **accepted_options
      has_scope :empty_stock, type: :boolean, **accepted_options
      has_scope :low_stock, type: :boolean, **accepted_options
      has_scope :order_by_low_stock, type: :boolean, **accepted_options
      has_scope :order_by_high_stock, type: :boolean, **accepted_options
      has_scope :only_limited_stock, as: :limited_stock, type: :boolean, **accepted_options
      has_scope :only_unlimited_stock, as: :unlimited_stock, type: :boolean, **accepted_options
      has_scope :only_pinned, as: :pinned, type: :boolean, **accepted_options
      
    end
  end

end