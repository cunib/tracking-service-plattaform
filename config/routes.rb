Rails.application.routes.draw do
  root 'businesses#index'
  resources :businesses, path: 'negocios'
  resources :delivery_men, path: 'repartidores'
  resources :orders, path: 'ordenes'
  resources :deliveries, path: 'repartos'
  resources :products, path: 'productos'
  resources :users, path: 'usuarios'

end
