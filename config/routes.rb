Rails.application.routes.draw do
  require "sidekiq/web"
  # devise_for :users
  devise_for :users, controllers: { sessions: 'users/sessions' }
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :profiles do
    resources :matches, only: %i[create destroy index update] do
      resources :chatrooms, only: :show do
        resources :messages, only: :create
      end
    end
  end

  resources :user_admins, only: %i[index show destroy]


  get "contato", to: "pages#contact", as: :contact
  post "contato", to: "pages#contact_submit", as: :contact_submit
  get "recursos", to: "pages#resources", as: :resources
  get "codigo-de-conduta", to: "pages#conduct", as: :conduct
  get "users/signup/:type", to: "registration#new", as: :new_type
  get "sobre", to: "pages#about", as: :about
end
