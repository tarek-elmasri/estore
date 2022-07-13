module Scopes::Dashboard::ItemsScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      apply_common_scopes only: options[:only], except: options[:except]
      has_scope :name_like, as: :name, only: options[:only], except: options[:except]
      has_scope :of_category_id, as: :category_id, only: options[:only], except: options[:except]
      has_scope :only_cards, type: :boolean, as: :cards, only: options[:only], except: options[:except]
      has_scope :has_discount, type: :boolean, only: options[:only], except: options[:except]
      has_scope :order_by_best_sales, type: :boolean, only: options[:only], except: options[:except]
      has_scope :order_by_high_price, type: :boolean, only: options[:only], except: options[:except]
      has_scope :order_by_low_price, type: :boolean, only: options[:only], except: options[:except]
      has_scope :empty_stock, type: :boolean, only: options[:only], except: options[:except]
      has_scope :low_stock, type: :boolean, only: options[:only], except: options[:except]
      has_scope :order_by_low_stock, type: :boolean, only: options[:only], except: options[:except]
      has_scope :order_by_high_stock, type: :boolean, only: options[:only], except: options[:except]
      has_scope :only_limited_stock, as: :limited_stock, type: :boolean, only: options[:only], except: options[:except]
      has_scope :only_unlimited_stock, as: :unlimited_stock, type: :boolean, only: options[:only], except: options[:except]
      has_scope :only_pinned, as: :pinned, type: :boolean, only: options[:only], except: options[:except]
      
    end
  end

end