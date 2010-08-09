ActionController::Routing::Routes.draw do |map|

  #OAuth 
  map.resources :oauth_clients
  map.test_request '/oauth/test_request', :controller => 'oauth', :action => 'test_request'
  map.access_token '/oauth/access_token', :controller => 'oauth', :action => 'access_token'
  map.request_token '/oauth/request_token', :controller => 'oauth', :action => 'request_token'
  map.authorize '/oauth/authorize', :controller => 'oauth', :action => 'authorize'
  map.revoke '/oauth/revoke', :controller => 'oauth', :action => 'revoke'
  map.invalidate '/oauth/invalidate', :controller => 'oauth', :action => 'invalidate'
  map.capabilities '/oauth/capabilities', :controller => 'oauth', :action => 'capabilities'
  map.oauth '/oauth', :controller => 'oauth', :action => 'index'

  #User 
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.resource :session
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources(:users, :member => {:toggle_admin => :put}) do |user|
    #Main Client-Facing Data Route
    user.resources :datasets
  end

  #Admin Data Route
  map.resources :datasets, :collection => {:cleanup => :delete}

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
  map.root :controller => "datasets"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'

  #For cucumber to be able to access static files.  Webrat can't access stuff 
  #in /public.  Capybara can't do stuff like look at HTTP response codes.
  #Other solutions would require hardcoding in a URL (because rails thinks 
  #the url is example.com.  in the test environment)
  map.connect 'tests/:path', :controller => 'tests', :action => 'show'
  map.connect 'tests/:path.:format', :controller => 'tests', :action => 'show'
end
