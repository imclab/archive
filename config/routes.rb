Archive::Application.routes.draw do
  namespace :admin do
    resource :dashboard, only: :show
    resources :sessions, except: [:update, :edit]
    resources :users, only: [:index, :destroy]
    resources :songs, only: [:index, :show, :destroy]
    resources :song_tags, only: :destroy
  end

  match 'sessions/oldest'   => 'sessions#index', sort: 'by_session_date'
  match 'sessions/newest'   => 'sessions#index', sort: 'by_session_date', reverse: true
  resources :sessions, only: :index

  match 'songs/highest_score' => 'songs#index', sort: 'by_score'
  match 'songs/most_tagged'   => 'songs#index', sort: 'by_count_of_tags'
  match 'songs/oldest'        => 'songs#index', sort: 'by_session_date'
  match 'songs/newest'        => 'songs#index', sort: 'by_session_date', reverse: true
  resources :songs, except: [:new, :update, :edit] do
    resources :votes, only: :create
  end

  resources :tags, except: [:new, :update, :edit]
  resources :users, except: [:index, :destroy, :show]
  match '/signup' => 'users#new'

  resources :user_sessions, only: [:new, :create, :destroy]
  match '/signin'  => 'user_sessions#new'
  match '/signout' => 'user_sessions#destroy'

  resources :comments, only: [:create, :destroy]

  root :to => "sessions#index"
end
