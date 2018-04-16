Rails.application.routes.draw do
  root 'users#home'

  resources :users, only: [:index, :edit, :update]
  resources :subscriptions, only: [:index, :destroy]

  post '/subscriptions/review_csv' => 'subscriptions#review_csv'
  post '/subscriptions/import' => 'subscriptions#import'
  get '/subscriptions/list' => 'subscriptions#subscriptions_list'

  get '/my_competitions' => 'competitions#my_competitions'
  resources :competitions, only: [] do
    get 'registrations' => 'competitions#show_registrations'
  end

  get '/profile' => 'users#edit'

  get '/wca_callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
end
