Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :customers, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  get '/books/popular_first' => 'books#popular_first'
  get '/books/price_low_to_high' => 'books#price_low_to_high'
  get '/books/price_high_to_low' => 'books#price_high_to_low'
  get '/books/:id/increase_quantity' => 'books#increase_quantity'

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
