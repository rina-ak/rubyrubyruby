Rails.application.routes.draw do
  root "albums#index"

  resources :albums do
    resources :comments, only: [:create, :destroy]
  end

  resources :album_proposals, only: [:new, :create]

  get "collections", to: "pages#collections", as: :collections
  get "about", to: "pages#about", as: :about
end