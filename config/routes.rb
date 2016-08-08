Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root "static_pages#home", :as => "home"

  # Static pages
  get "help" => "static_pages#help"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"

  # url name, controller action
  get "signup" => "users#new"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"

  # user paths -> nested path of users/1/following & /following which correspond do db selections
  resources :users do
    member do
      get :following, :followers
    end
  end
  # account activations
  resources :account_activations, :only => [:edit]
  # password resets
  resources :password_resets, :only => [:new, :edit, :create, :update]
  # microposts
  resources :microposts, :only => [:create, :destroy]

  # Creates the path to a unexisting relationships controller
  resources :relationships, :only => [:create, :destroy]

end
