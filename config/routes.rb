require 'api_constraints'

Rails.application.routes.draw do
  root 'businesses#index'

  resources :businesses, path: 'negocios'
  resources :delivery_men, path: 'repartidores'

  resources :orders, path: 'ordenes'

  resources :deliveries, path: 'repartos' do
    member do
      get 'posiciones', action: :positions, as: :positions
    end
  end

  resources :products, path: 'productos'

  post '/cancel_order/:id', as: :cancel, to: 'orders#cancel'
  post '/suspend_order/:id', as: :suspend, to: 'orders#suspend'

  get '/mapas', as: :index, to: 'maps#index'

  # API
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :orders, only: [:index]
      resources :businesses, only: [:index]
    end
  end

  match '*path', to: 'application#handle_404', via: :all
end
