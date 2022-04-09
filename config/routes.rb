Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints subdomain: "api" do
    scope module: "api" do

      scope module: "v1" do

        scope :sessions do
          post "login" => "sessions#login"
          post "register" => "sessions#register"
          patch "refresh" => "sessions#refresh"
          delete "logout" => "sessions#logout"
          post "forget_password" => "sessions#forget_password"
          post "validate_token" => "sessions#validate_password_token"
          patch "reset_password" => "sessions#reset_password"        
        end
        
        scope :users do
          get "/" => "users#index"
          patch "/" => "users#update"
        end

        scope :cart_items do
          post "/" => "cart_items#create"
          delete "/" => "cart_items#destroy"
          patch "/" => "cart_items#update"
          get "/" => "cart_items#index"
        end

        scope module: "dashboard" do
          scope :dashboard do
            scope :users do
              get "/" => "users#index"
              patch "/" => "users#update"
            end
            scope :authorizations do
              patch "/" => "authorizations#update"
            end

            scope :category do
              get "/" => "categories#index"
              post "/" => "categories#create"
              patch "/" => "categories#update"
              delete "/" => "categories#destroy"
            end
            
            scope :staff_actions do
              get "/" => "staff_actions#index"
            end
          end
        end


      end

      
    end
  end

end
