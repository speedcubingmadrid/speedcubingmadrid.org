Rails.application.routes.draw do
  root 'posts#home'

  resources :users, only: [:index, :edit, :update]
  # To not ruin our pagerank, we need a "/news" routes with slugs, so that old links keep working
  resources :news, :controller => "posts"
  resources :subscriptions, only: [:index, :destroy]
  resources :tags, only: [:index, :edit, :update]

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
  post '/signin_with_wca' => 'sessions#signin_with_wca', :as => :signin_with_wca
  get '/signout' => 'sessions#destroy', :as => :signout
end
