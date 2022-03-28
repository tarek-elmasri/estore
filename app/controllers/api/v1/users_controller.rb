class Api::V1::UsersController < ApplicationController 
  before_action :authenticate_user
  # before_action :load_authenticated_user

  def index
    respond({user: Current.user.reload})
  end


end
