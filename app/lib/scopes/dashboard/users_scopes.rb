module Scopes::Dashboard::UsersScopes
  extend ActiveSupport::Concern
  include Scopes::CommonScopes::Controllers


  class_methods do
    define_method :apply_controller_scopes do |options={}|
      accepted_options= {only: options.dig(:only), except: options.dig(:except)}
      apply_common_scopes **accepted_options
      has_scope :only_blocked, as: :blocked, type: :boolean, **accepted_options
      has_scope :only_staff, as: :staff, type: :boolean, **accepted_options
      has_scope :by_phone_no, as: :phone_no, **accepted_options
      has_scope :by_email, as: :email, **accepted_options
      has_scope :by_city, as: :city, **accepted_options
      has_scope :by_gender, **accepted_options
      has_scope :age_below, **accepted_options
      has_scope :age_above, **accepted_options 
      has_scope :age_between, type: :array, **accepted_options
      has_scope :exclude_id, **accepted_options 
    end
  end

end