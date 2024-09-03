Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      scope '/auth' do
        post 'login', to: 'auth#create'
        get 'user' , to: 'users#show'
      end

      scope '/wallets' do
      end

      scope '/transactions' do
      end

      scope '/stocks' do
        get 'stock/:symbol', to: 'stocks#show'
        get 'stocks', to: 'stocks#index'
        get 'stocks/all', to: 'stocks#all'
      end
    end
  end
end
