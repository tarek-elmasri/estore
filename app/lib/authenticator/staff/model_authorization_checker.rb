module Authenticator::Staff::ModelAuthorizationChecker 
  extend ActiveSupport::Concern

  included do
    before_create :authorize_create
    before_update :authorize_update
    before_destroy :authorize_destroy

    private
    def authorize_create
      raise Errors::Unauthorized unless Current.user.send("is_authorized_to_create_#{self.class.to_s.downcase}?")
    end

    def authorize_update
      raise Errors::Unauthorized unless Current.user.send("is_authorized_to_update_#{self.class.to_s.downcase}?")

    end

    def authorize_destroy
      raise Errors::Unauthorized unless Current.user.send("is_authorized_to_delete_#{self.class.to_s.downcase}?")

    end
  end

end