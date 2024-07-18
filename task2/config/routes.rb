Rails.application.routes.draw do


  namespace :api do
    namespace :v1 do
      resources :songs
      resources :artists
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post 'signup', to: 'authentication#signup'
  post 'login', to: 'authentication#login'
  delete 'logout', to: 'authentication#logout'
   get '/users', to: 'authentication#index'
   put '/update/:id', to: 'authentication#update'

end
