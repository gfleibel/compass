Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users do
    resources :mentee_matches, only: %i[new create destroy index]
    resources :mentor_matches, only: %i[new create destroy index]
  end

  get "contato", to: "pages#contact", as: :contact
  get "recursos", to: "pages#resources", as: :resources
  get "codigo-de-conduta", to: "pages#conduct", as: :conduct
  get "users/signup/:type", to: "registration#new", as: :new_type
end
