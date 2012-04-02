Archive::Application.routes.draw do
  match 'sessions/oldest'   => 'sessions#index', sort: 'by_session_date'
  match 'sessions/newest'   => 'sessions#index', sort: 'by_session_date',
                                                 reverse: true
  resources :sessions, :except => [:update, :edit]

  match 'songs/most_tagged' => 'songs#index', sort: 'by_count_of_tags'
  match 'songs/oldest'      => 'songs#index', sort: 'by_session_date'
  match 'songs/newest'      => 'songs#index', sort: 'by_session_date',
                                              reverse: true
  resources :songs, :except => [:new, :update, :edit]

  resources :tags, :except => [:new, :update, :edit]
  resources :users, :except => :show
  match '/signup' => 'users#new'

  resources :user_sessions, :only => [:new, :create, :destroy]
  match '/signin'  => 'user_sessions#new'
  match '/signout' => 'user_sessions#destroy'

  resources :comments, :only => [:create, :destroy]

  root :to => "sessions#index"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
