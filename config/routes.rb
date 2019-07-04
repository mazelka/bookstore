Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :customers, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  get '/books/popular_first' => 'books#popular_first'
  get '/books/price_low_to_high' => 'books#price_low_to_high'
  get '/books/price_high_to_low' => 'books#price_high_to_low'
  get '/books/:id/increase_quantity' => 'books#increase_quantity'
  post 'books/add_to_cart' => 'carts#add_to_cart'
  get 'cart' => 'carts#show_cart'
  get 'cart/remove_item' => 'carts#remove_item'
  get 'cart/increase_quantity' => 'carts#increase_quantity'
  get 'cart/decrease_quantity' => 'carts#decrease_quantity'
  post 'cart/apply_coupon' => 'carts#apply_coupon'
  post 'orders' => 'orders#create'
  get 'books/category' => 'books#category'
  get 'settings' => 'settings#index'
  # post 'checkout/update' => 'checkout#update'
  # get 'checkout/delivery' => 'checkout#delivery'
  # post 'checkout/update_delivery' => 'checkout#update_delivery'

  # devise÷_sc :customer
  # do increase_quantity
  #   get '/login' => 'devise/sessions#new'
  #   post '/login' => 'devise/sessions#create'
  #   post '/sign_up' => 'devise/registrations#new'
  # end
  resources :reviews
  resources :categories
  resources :books
  resources :authors
  resources :checkout
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
