class Api::V1::Dashboard::Base < ApplicationController
  before_action :authenticate_user
  before_action :load_authenticated_user
  before_action :authorize_user


  def authorize_user
    respond_forbidden unless Current.user.is_staff? || Current.user.is_admin? 
  end
end