Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  scope "(:locale)", locale: /en/ do
    get "users/show"
    get "users/new"
    root "static_pages#home"
    get "static_pages/help"
    get "static_pages/contact"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, only: [:new, :create, :edit, :update]

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
end
