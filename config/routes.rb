Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :customers, controllers: {
                           omniauth_callbacks: 'omniauth_callbacks',
                           registrations: 'customers/registrations',
                         }
  post 'add_to_cart' => 'carts#add_to_cart'
  get 'cart/remove_item' => 'carts#remove_item'
  get 'cart/increase_quantity' => 'carts#increase_quantity'
  get 'cart/decrease_quantity' => 'carts#decrease_quantity'
  post 'cart/apply_coupon' => 'carts#apply_coupon'
  put 'settings/update' => 'settings#update'
  resources :reviews, only: :create
  resources :carts, only: :index
  resources :orders, only: [:index, :create]
  resources :quick_registrations, only: [:index, :create]
  resources :checkout, only: [:show, :update]
  resources :settings, only: [:index]
  resources :categories, only: :show do
    resources :books, shallow: true do
    end
  end
  resources :books, only: :index

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
