require 'api_constraints'

Rails.application.routes.draw do
  root 'businesses#index'

  resources :businesses, path: 'locales' do

    member do
      get 'editar-estrategia', action: :edit_strategy, as: :edit_strategy
    end

    resources :products, path: 'productos', path_names: { new: 'nuevo' }

    resources :orders, path: 'ordenes' do
      member do
        post :process, as: :process, to: 'orders#process_order'
        post :mark_as_sended, as: :mark_as_sended, to: 'orders#mark_as_sended_order'
        post :dispatch, as: :dispatch, to: 'orders#dispatch_order'
        post :suspend, as: :suspend, to: 'orders#suspend'
        post :cancel, as: :cancel, to: 'orders#cancel'
        get 'posiciones', action: :positions, as: :positions
      end
    end

    resources :delivery_men, path: 'repartidores' do
      member do
        get 'repartos', action: :deliveries, as: :deliveries
      end
    end

    resources :deliveries, path: 'repartos' do
      member do
        get 'posiciones', action: :positions, as: :positions
        post :activate, as: :activate, to: 'deliveries#activate'
      end
    end

  end

  scope 'seguilo' do
    get '/', as: :trackit_index, to: 'purchases#index'
    resources :businesses, path: 'locales', only: [] do

      get '/realizar-pedido', as: :new_order, to: 'orders#new_order'
      get '/segui-tu-pedido', as: :track_order, to: 'orders#track_order'
      post '/crear-pedido', as: :create_order, to: 'orders#create_order'
    end
  end

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
        end
      end
      resources :traces, only: [:create]
    end
  end

  match '*path', to: 'application#handle_404', via: :all
end
