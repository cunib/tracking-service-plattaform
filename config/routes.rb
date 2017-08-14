require 'api_constraints'

Rails.application.routes.draw do
  root 'businesses#index'

  resources :businesses, path: 'locales' do
    get '/realizar-pedido', as: :make_order, to: 'businesses#make_order'

    resources :products, path: 'productos', path_names: { new: 'nuevo' }

    resources :orders, path: 'ordenes' do
      member do
        post :cancel, as: :cancel, to: 'orders#cancel'
        post :suspend, as: :suspend, to: 'orders#suspend'
      end
    end

    resources :delivery_men, path: 'repartidores'

    resources :deliveries, path: 'repartos' do
      member do
        get 'posiciones', action: :positions, as: :positions
      end
    end

  end

# resources :delivery_men, path: 'repartidores'
#
# resources :orders, path: 'ordenes'
#
# resources :deliveries, path: 'repartos' do
#   member do
#     get 'posiciones', action: :positions, as: :positions
#   end
# end

#  post '/cancel_order/:id', as: :cancel, to: 'orders#cancel'
#  post '/suspend_order/:id', as: :suspend, to: 'orders#suspend'

  #get '/mapas', as: :index, to: 'maps#index'

  get '/seguilo', as: :trackit_index, to: 'purchases#index'

  # API
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :orders, only: [:index] do
        member do
          post 'mark_as_finalized', action: :mark_as_finalized, as: :mark_as_finalized
          post 'mark_as_suspended', action: :mark_as_suspended, as: :mark_as_suspended
        end
      end
      resources :businesses, only: [:index]
      resources :delivery_men, only: [:show] do
        member do
          get 'active_delivery_orders', action: :active_delivery_orders, as: :active_delivery_orders
          post 'new_positions', action: :new_positions, as: :new_positions
        end
      end
    end
  end

  match '*path', to: 'application#handle_404', via: :all
end
