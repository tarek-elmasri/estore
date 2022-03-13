class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  

  def hello
    render json: {hello: "hello"}
  end

end
