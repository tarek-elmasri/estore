class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_user

  def me
    render json: {hello: "hello"}
  end
end
