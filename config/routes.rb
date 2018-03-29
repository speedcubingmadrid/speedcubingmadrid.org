Rails.application.routes.draw do
  root 'users#home'

  resources :users, only: [:index, :edit, :update]

  get '/profile' => 'users#edit'

  get '/wca_callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
end
