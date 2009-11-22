ActionController::Routing::Routes.draw do |map|

  map.resources :games,
    :member => {
      :play => :get
    }

  map.resources :game_slots

	map.login '/login', :controller => 'sessions', :action => 'new'
	map.logout '/logout', :controller => 'sessions', :action => 'destroy'
	map.register '/register', :controller => 'users', :action => 'new'

  map.resources :users
  
	map.resources :tournaments,
    :member => {
      :manage_type => :get,
      :update_type => :post,
      :manage_teams => :get,
      :update_teams => :post,
      :schedule => :get,
      :update_schedule => :post,
      :add_team => :post,
      :remove_team => :post,
      :generate_empty_schedule => :post,
      :generate_round_robin_schedule => :post,
      :play => :get
    }
  
	map.resources :players,
		:member => {
			:avatar => :get,
			:add_avatar => :post,
			:remove_avatar => :delete
		}
   
	map.resources :teams,
		:member => { 
			:manage_players => :get,
			:add_player => :post,
			:remove_player => :post
		}

	map.resources :people
	
  map.resource :session

	map.root :controller => 'ftm'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
