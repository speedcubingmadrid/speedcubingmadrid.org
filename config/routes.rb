Rails.application.routes.draw do
  resources :calendar_events
  resources :bags
  root 'posts#home'

  resources :users, only: [:index, :edit, :update]
  get 'users/import' => 'users#import'
  post 'users/import' => 'users#import_from_wca'

  # To not ruin our pagerank, we need a "/news" routes with slugs, so that old links keep working
  resources :news, :controller => "posts"
  get '/news/tag/:tag' => 'posts#tag_index', :as => :posts_by_tag
  # Some slug have slashes, we need a globbing routes (and an appropriate path helper too)
  get '/news/*id' => 'posts#show', :as => 'news_slug', :format => false
  resources :subscriptions, only: [:index, :destroy]
  resources :tags, only: [:index, :edit, :update]
  resources :hardwares

  post '/subscriptions/review_csv' => 'subscriptions#review_csv'
  post '/subscriptions/import' => 'subscriptions#import'
  get '/subscriptions/list' => 'subscriptions#subscriptions_list'

  get '/my_competitions' => 'competitions#my_competitions'
  get '/upcoming_comps' => 'competitions#upcoming_comps'
  get '/upcoming_champs' => 'competitions#manage_big_champs'
  post '/update_champs' => 'competitions#update_big_champs'

  resources :competitions, only: [:index]
  get 'competitions/official/:competition_id/registrations' => 'competitions#show_registrations', :as => :competition_registrations
  get 'competitions/historique' => 'competitions#old_competitions_list'
  get 'competitions/:slug' => 'competitions#show_competition_page', :as => 'old_competitions'

  get '/profile' => 'users#edit'

  get '/wca_callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  post '/signin_with_wca' => 'sessions#signin_with_wca', :as => :signin_with_wca
  get '/signout' => 'sessions#destroy', :as => :signout
end
