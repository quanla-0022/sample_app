Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    post "/signup", to: "users#create"
    delete "/logout", to: "sessions#destroy"
    root "static_pages#home"
    resources :users
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i(new create edit update)
end
