Archive::Application.routes.draw do
  match 'sessions/oldest'   => 'sessions#index', sort: 'by_session_date'
  match 'sessions/newest'   => 'sessions#index', sort: 'by_session_date', reverse: true
  resources :sessions, except: [:update, :edit]

  match 'songs/highest_score' => 'songs#index', sort: 'by_score'
  match 'songs/most_tagged'   => 'songs#index', sort: 'by_count_of_tags'
  match 'songs/oldest'        => 'songs#index', sort: 'by_session_date'
  match 'songs/newest'        => 'songs#index', sort: 'by_session_date', reverse: true
  resources :songs, except: [:new, :update, :edit] do
    resources :votes, only: :create
  end

  resources :tags, except: [:new, :update, :edit]
  resources :users, except: :show
  match '/signup' => 'users#new'

  resources :user_sessions, only: [:new, :create, :destroy]
  match '/signin'  => 'user_sessions#new'
  match '/signout' => 'user_sessions#destroy'

  resources :comments, only: [:create, :destroy]

  root :to => "sessions#index"
end
