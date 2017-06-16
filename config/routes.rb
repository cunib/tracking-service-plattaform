Rails.application.routes.draw do
  root 'business#index'
  resources :businesses, path: 'negocios'
  resources :delivery_men, path: 'repartidores'
  resources :orders, path: 'ordenes'
  resources :deliveries, path: 'repartos'
  resources :products, path: 'productos'
  post	'/cancel_order/:id', as: :cancel,	to: 'orders#cancel'

end
