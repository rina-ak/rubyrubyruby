Rails.application.routes.draw do
  devise_for :users
  root "albums#index"

  resources :albums do
    resources :comments, only: [:create, :destroy]
  end

  resources :album_proposals, only: [:index, :new, :create]

  get "collections", to: "pages#collections", as: :collections
  get "about", to: "pages#about", as: :about
end