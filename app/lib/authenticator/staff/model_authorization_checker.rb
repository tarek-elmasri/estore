module Authenticator::Staff::ModelAuthorizationChecker 
  extend ActiveSupport::Concern

  included do
    before_create :authorize_create
    before_update :authorize_update
    before_destroy :authorize_destroy

    private
    def authorize_create
      # return if self.class.to_s == "User"
      return if self.is_a?(User)
      # return authorize_update if self.class.to_s == "Authorization"
      return authorize_update if self.is_a?(Authorization)
      raise Errors::Unauthorized unless Current.user.send("is_authorized_to_create_#{self.class.to_s.downcase}?")
    end

    def authorize_update
      return if self.class.to_s == "User" && Current.user.id == self.id
      raise Errors::Unauthorized unless Current.user.send("is_authorized_to_update_#{self.class.to_s.downcase}?")
    end

    def authorize_destroy
      return if self.class.to_s == "User"
      return authorize_update if self.class.to_s == "Authorization"
      raise Errors::Unauthorized unless Current.user.send("is_authorized_to_delete_#{self.class.to_s.downcase}?")

    end
  end

end