class Api::V1::ForgetPasswords < ApplicationController

  def index
    user = User.find_by_password_token!(params.require(:token))
    respond({email: user.email})
  end


  def create
    User.request_forget_password_token_by_email(params.require(:email))
    respond_ok()
  end

  def update
    Current.user = User.find_by_password_token!(params.require(:token))
    Current.user.reset_password(params.require(:new_password))
    create_session_cookies(Current.user)
    respond({tokens: Current.user.tokens})
  end


end