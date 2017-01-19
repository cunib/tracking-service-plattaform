Rails.application.routes.draw do
  root 'businesses#index'
  resources :businesses
  resources :delivery_men

end
