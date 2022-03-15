class Api::V1::SessionsController < ApplicationController
  

  def me
    render json: {hello: "hello"}
  end

  def login

  end


  def signup
    user = User.new(sessions_params)
    
    if user.save
      session[:session_id] = user.session.id
      repond({
        access_token: user.generate_access_token,
        user: user
      })
    else
      un_processable(user.errors)
    end

  end

  def logout

  end

  private

  def sessions_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :phone_no,
      :email,
      :password,
      :gender
    )
  end

  def login_via_web

  end

  def login_via_mobile

  end
end
