Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  resources :albums do
    collection do
      get :search
    end
    resources :comments, only: [:create, :destroy]
  end

  resources :album_proposals, only: [:new, :create]

  namespace :admin do
    root to: "dashboard#show"
    resources :album_proposals, only: [:index, :show, :destroy]
    resources :albums, only: [:index]
    resources :comments, only: [:index, :destroy]
    resources :subscribers, only: [:index, :destroy]
    resources :users, only: [:index]
  end

  get "collections", to: "pages#collections", as: :collections
  get "collections/:slug", to: "pages#collection", as: :collection
  get "about", to: "pages#about", as: :about
  get "teaser", to: "pages#teaser", as: :teaser
  get "privacy", to: "pages#privacy", as: :privacy
  resources :subscribers, only: [ :create ]
end