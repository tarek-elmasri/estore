Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints subdomain: "api" do
    scope module: "api" do

      scope module: "v1" do

        scope :sessions do
          get "/" => "sessions#me"
          post "login" => "sessions#login"
          post "register" => "sessions#register"
          patch "refresh" => "sessions#refresh"
          delete "logout" => "sessions#logout"
          post "forget_password" => "sessions#forget_password"
          post "validate_token" => "sessions#validate_password_token"
          patch "reset_password" => "sessions#reset_password"        
        end


      end

      
    end
  end

end
