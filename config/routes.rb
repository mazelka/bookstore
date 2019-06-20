Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :customers, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # devise÷_sc :customer
  # do
  #   get '/login' => 'devise/sessions#new'
  #   post '/login' => 'devise/sessions#create'
  #   post '/sign_up' => 'devise/registrations#new'
  # end
  resources :reviews
  resources :categories
  resources :books
  resources :authors
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
