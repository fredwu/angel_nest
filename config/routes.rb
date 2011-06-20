AngelNest::Application.routes.draw do
  devise_for :users

  resources :users do
    resources :startups
    resource  :investor
  end

  resources :investors,     :only => :index
  resources :entrepreneurs, :only => :index
  resources :startups do
    resources :messages,    :only => [:index, :create], :as => :comments
  end

  match 'u/:username'            => 'users#show',            :via => :get, :as => :username

  match 'my/profile'             => 'users#show',            :via => :get
  match 'my/home'                => 'users#home',            :via => :get
  match 'my/micro_posts'         => 'users#add_micro_post',  :via => :post
  match 'my/startups'            => 'startups#my_index',     :via => :get

  match 'my/follow/:target_id'   => 'users#follow_target',   :via => :post, :as => :follow_target
  match 'my/unfollow/:target_id' => 'users#unfollow_target', :via => :post, :as => :unfollow_target

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
  root :to => 'users#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
