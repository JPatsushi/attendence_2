Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  # get 'users/new' , as: 'signup'
  get  '/signup',   to: 'users#new'
  post '/signup',  to: 'users#create'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :time_cards do
    member do
      patch :add, :subtract, :updata, :up_overwork
      post :update, :authenticate, :authenticate_2
    end
  end
  
  resources :users do
    collection do
      post :import 
      get :working_member 
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  
  resources :monthly_authentications, only: [:update, :create] 
  resources :locations, only: [:index, :create, :destroy, :update]
  patch '/monthly_authentications', to: 'monthly_authentications#monthly_update'
  
end
