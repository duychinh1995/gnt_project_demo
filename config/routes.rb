Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/edit"
  get "sessions/new"
  get "users/new"
  root "products#index"
  get "/search", to: "filters#show"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/your_cart", to: "carts#show"
  delete "/delete_cart", to: "carts#destroy"
  get "/plus_product", to: "carts#plus"
  get "/minus_product", to: "carts#minus"
  get "/checkout", to: "orders#new"
  post "/order_products", to: "orders#create"
  resources :users, except: %i(index destroy)
  resources :order_details
  resources :carts
  resources :account_activations, only: [:edit]
  resources :password_resets, except: [:index, :destroy, :show]
  resources :products, only: [:show, :index]
  resources :orders
  namespace :admin do
    resource :admin, only: :index
    root to: "admin#index"
    resources :products, except: :show do
      collection { post :import }
    end
    resources :orders, except: [:new, :create, :destroy]
    resources :categories
    resources :users, only: %i(index destroy)
  end
end
