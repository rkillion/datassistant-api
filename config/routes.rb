Rails.application.routes.draw do
  resources :instances, only: [:show]
  # resources :logs
  resources :base_types, only: [:index,:show]
  resources :types, only: [:index,:show]
  resources :datassistants
  get "/me", to: "users#show"
  post "/signup", to: "users#create"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  post "/new", to: "actions#new"
  post "/note", to: "actions#note"
  post "/assign", to: "actions#assign"
  post "/add", to: "actions#add"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
