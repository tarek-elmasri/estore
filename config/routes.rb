Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints subdomain: "api" do
    scope module: "api" do

      scope module: "v1" do
        scope :v1 do
          get "/" => "sessions#me"
        end
      end

      
    end
  end

end
