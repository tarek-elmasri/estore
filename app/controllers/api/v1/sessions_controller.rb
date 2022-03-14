class SessionsController < ApplicationController
  def me
    render json: {hello: "hello"}
  end
end
