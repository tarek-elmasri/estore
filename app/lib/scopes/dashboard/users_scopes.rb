module Scopes::Dashboard::UsersScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      apply_common_scopes only: options[:only], except: options[:except]
      has_scope :only_blocked, as: :blocked, type: :boolean, only: options[:only], except: options[:except]
      has_scope :only_staff, as: :staff, type: :boolean, only: options[:only], except: options[:except]
      has_scope :by_phone_no, as: :phone_no, only: options[:only], except: options[:except]
      has_scope :by_email, as: :email, only: options[:only], except: options[:except]
      has_scope :by_city, as: :city, only: options[:only], except: options[:except]
      has_scope :by_gender, only: options[:only], except: options[:except]
      has_scope :age_below, only: options[:only], except: options[:except]
      has_scope :age_above, only: options[:only], except: options[:except] 
    end
  end

end