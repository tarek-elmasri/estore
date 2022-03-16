class User < ApplicationRecord
  include Authenticator::Model
  
  

  has_one :cart
  has_one :session







end
