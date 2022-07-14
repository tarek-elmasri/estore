module Scopes::CommonScopes::Controllers
  extend ActiveSupport::Concern

  class_methods do
    def apply_common_scopes(options={})
      accepted_options= {only: options.dig(:only), except: options.dig(:except)}
      has_scope :paginate, using: %i[page per], type: :hash, allow_blank: true, **accepted_options
      has_scope :order_by_recent, type: :boolean, **accepted_options
      has_scope :of_ids, as: :id, **accepted_options
    end
  end


end