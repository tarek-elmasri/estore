class Api::V1::UpdatePasswordsController < ApplicationController

  before_action :authenticate_user

  def update
    User::ResetPassword.new(Current.user.reload)
                    .update_old_password(params.require(:old_password), params.require(:new_password))

    respond_ok
  end

end