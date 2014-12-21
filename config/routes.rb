Rails.application.routes.draw do

  resources :bets

  resources :leagues

  resources :games

  resources :championships

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get '/users/sign_out', :to => 'devise/sessions#destroy', :as => :sign_out
  end

 # devise_scope :user do
 #   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
 # end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  get '/leagues/:id/scoreboard', to: 'leagues#scoreboard', as: 'league_scoreboard'

  get '/leagues/:id/leaderboard', to: 'leagues#leaderboard', as: 'league_leaderboard'

  get '/get_users', to: 'leagues#get_users', as: 'get_users'

  get '/leagues/:id/games', to: 'leagues#games', as: 'league_games'

  get '/leagues/:id/mybets', to: 'leagues#mybets', as: 'league_mybets'

  get '/leagues/:id/settings', to: 'leagues#settings', as: 'league_settings'

  get '/users/:id', to: 'users#show', as: 'user_profile'

  #devise_for :users, :controllers => { :registrations => "users/registrations_controller" }

  post '/bets/update_multiple', to: 'bets#update_multiple', as: 'update_multiple_bets'

  get '/notifications/:type/:id', to: 'notifications#show', as: 'notification'

  put '/users/:id', to: 'users#update', as: 'edit_user_profile'

end
