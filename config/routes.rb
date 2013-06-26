Archive::Application.routes.draw do
  namespace :admin do
    resource :dashboard, only: :show
    resources :sessions, except: [:update, :edit]
    resources :users, only: [:index, :destroy]
    resources :songs, only: [:index, :show, :destroy]
    resources :song_tags, only: :destroy
  end

  get 'sessions/oldest'   => 'sessions#index', sort: 'by_session_date'
  get 'sessions/newest'   => 'sessions#index', sort: 'by_session_date', reverse: true
  resources :sessions, only: :index

  get 'songs/highest_score' => 'songs#index', sort: 'by_score'
  get 'songs/most_tagged'   => 'songs#index', sort: 'by_count_of_tags'
  get 'songs/oldest'        => 'songs#index', sort: 'by_session_date'
  get 'songs/newest'        => 'songs#index', sort: 'by_session_date', reverse: true
  resources :songs, except: [:new, :update, :edit] do
    resources :votes, only: :create
  end

  resources :tags, except: [:new, :update, :edit]
  resources :users, except: [:index, :destroy, :show]
  get '/signup' => 'users#new'

  resources :user_sessions, only: [:new, :create, :destroy]
  get '/signin'  => 'user_sessions#new'
  delete '/signout' => 'user_sessions#destroy'

  resources :comments, only: [:create, :destroy]

  root :to => "sessions#index"
end
