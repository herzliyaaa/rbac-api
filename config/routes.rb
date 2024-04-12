Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      namespace :postgres do
        resources :roles, only: [:index, :create]
        resources :users, only: [:index, :create, :show]
      end

      namespace :mssql do
        resources :roles, only: [:index, :create]
        resources :users, only: [:index, :create, :show]
      end
    end
  end
end
