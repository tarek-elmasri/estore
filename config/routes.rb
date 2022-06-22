Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints subdomain: "api" do
    scope module: "api" do

      scope module: "v1" do

        scope :sessions do
          post "/" => "sessions#create"
          patch "/" => "sessions#update"
          delete "/" => "sessions#delete"       
        end

        scope :forget_password do
          post "/" => "forget_passwords#create"
          get "/" => "forget_passwords#index"
          patch "/" => "forget_passwords#update" 
        end
        
        scope :users do
          get "/" => "users#index"
          patch "/" => "users#update"
          post "/" => 'users#create'
        end

        scope :items do
          get '/' => 'items#index'
        end

        scope :carts do
          get '/' => 'carts#index'
        end

        scope :cart_items do
          post "/" => "cart_items#create"
          delete "/" => "cart_items#destroy"
          patch "/" => "cart_items#update"
          get "/" => "cart_items#index"
        end
# 927af049-af5b-4c3b-a25a-3542158a96b6
        scope :orders do
          post "/" => "orders#create"
        end

        scope :payments do
          post "/" => "payments#create"
          patch "/" => "payments#update"
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

            scope :cards do
              get "/" => "cards#index"
              post "/" => "cards#create"
              patch "/" => "cards#update"
              delete "/" => "cards#delete"
            end
          end
        end


      end

      
    end
  end

end
