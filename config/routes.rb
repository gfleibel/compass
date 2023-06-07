Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :profiles do
    resources :matches, only: %i[create destroy index update]
  end

  get "contato", to: "pages#contact", as: :contact
  post "contato", to: "pages#contact_submit", as: :contact_submit
  get "recursos", to: "pages#resources", as: :resources
  get "codigo-de-conduta", to: "pages#conduct", as: :conduct
  get "users/signup/:type", to: "registration#new", as: :new_type
end
