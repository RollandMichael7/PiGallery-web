Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"

  resources :subjects, only: [:index, :show]
  resources :locations, only: [:index, :show]
  resources :months, only: [:index, :show]
  resources :imports, only: [:index, :show]
  resources :images, only: [:show]

  resources :random, only: [:index]
  resources :welcome, only: [:index]
end
