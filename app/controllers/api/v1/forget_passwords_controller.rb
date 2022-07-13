class Api::V1::ForgetPasswordsController < ApplicationController

  def index
    user = User.find_by_password_token!(params.require(:token))
    respond({email: user.email})
  end


  def create
    User::RequestResetPasswordByEmail.new(params.require(:email), params.require(:reset_link))
                                          .create!
    respond_ok()
  end

  def update
    user = User.find_by_password_token!(params.require(:token))
    User::ResetPassword.new(user).set_new_password(params.require(:new_password))
    create_session_cookies(user)
    respond({tokens: user.tokens})
  end


end