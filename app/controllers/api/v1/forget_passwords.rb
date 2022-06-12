class Api::V1::ForgetPasswords < ApplicationController

  def index
    user = User.find_by_password_token!(params[:token])
    respond({email: user.email})
  end


  def create
    User.request_forget_password_token_by_email(params[:email])
    respond_ok()
  end

  def update
    Current.user = User.find_by_password_token!(params[:token])
    Current.user.reset_password params[:password]
    create_session_cookies(Current.user)
    respond({tokens: Current.user.tokens})
  end

end