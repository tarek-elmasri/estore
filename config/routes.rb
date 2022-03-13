Rails.application.routes.draw do
  get 'sessions/me'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints subdomain: "api" do
    get "/" => "sessions#me"
  end

end
