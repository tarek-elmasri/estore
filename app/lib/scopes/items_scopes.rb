module Scopes::ItemsScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      apply_common_scopes only: options[:only], except: options[:except]
      has_scope :name_like, as: :name
      has_scope :of_category_id, as: :category_id
      has_scope :only_cards, type: :boolean, as: :cards
      has_scope :has_discount, type: :boolean
      has_scope :order_by_best_sales, type: :boolean
      has_scope :order_by_high_price, type: :boolean
      has_scope :order_by_low_price, type: :boolean
      has_scope :low_stock, type: :boolean
      has_scope :only_pinned, as: :pinned, type: :boolean

    end
  end

end