Rails.application.routes.draw do
  devise_for :users

  root "rooms#index"
  resources :users, only: [:edit, :update]
  resources :rooms, only: [:create, :new] do
    resources :messages, only: [:new, :create, :index]
  end
end
