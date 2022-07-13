class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Scopes::CommonScopes::Models

  
end
