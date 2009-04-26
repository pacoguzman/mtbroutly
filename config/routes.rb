ActionController::Routing::Routes.draw do |map|

  # No lo enlazamos con users, ya que sus rutas ya están definidas en tog_user
  map.resources :routes, :path_prefix => "users/:user_id", :name_prefix => "user_",
    :only => :index, :collection => {:your_favorites => :get, :created_by_you => :get,
    :close_to_you => :get}
  #PENDING Fijar la acción search de las rutas
  map.resources :routes, :only => [:show, :index],
    :collection => { :search => :get, :newest => :get, :highlighted => :get },
    :member => { :big => :get, :rate => :post }
  map.resources :waypoints

  map.namespace(:member) do |member|
    member.resources :routes, :except => :show,
      :collection => { :upload => :get, :uploaded => :post }
  end

  map.with_options(:controller => 'member/favorites') do |favorite|
    favorite.add_favorite 'favorites', :action => 'create'
    favorite.remove_favorite 'favorites/:id/remove', :action => 'remove'
  end

  map.dashboard 'member/dashboard', :controller => 'member/dashboard'
  # Defined in tog_core
  #map.member_dashboard 'member/dashboard', :controller => 'member/dashboard'
  map.activate '/activate', :controller => 'users', :action => 'activate'


  map.routes_from_plugin 'tog_conclave'
  map.routes_from_plugin 'tog_mail'
  map.routes_from_plugin 'tog_social'
  map.routes_from_plugin 'tog_user'
  map.routes_from_plugin 'tog_core'

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
