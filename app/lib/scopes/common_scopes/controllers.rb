module Scopes::CommonScopes::Controllers
  extend ActiveSupport::Concern

  class_methods do
    def apply_common_scopes(options={})
      has_scope :paginate, using: %i[page per], type: :hash, allow_blank: true, only: options[:only], except: options[:except]
      has_scope :order_by_recent, type: :boolean, only: options[:only], except: options[:except]
      has_scope :of_ids, as: :id, only: options[:only], except: options[:except]
    end
  end


end