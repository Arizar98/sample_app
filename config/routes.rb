Rails.application.routes.draw do
  get 'sessions/new'
  scope "(:locale)", locale: /en/ do
    get "users/show"
    get "users/new"
    root "static_pages#home"
    get "static_pages/help"
    get "static_pages/contact"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    resources :users, only: %i(show new)

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
end
