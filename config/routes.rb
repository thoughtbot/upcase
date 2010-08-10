ActionController::Routing::Routes.draw do |map|

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # map.home '', :controller => 'home', :action => 'dashboard'
  # map.with_options :controller => 'sessions'  do |m|
  #   m.login  '/login',  :action => 'new'
  #   m.logout '/logout', :action => 'destroy'
  # end

  HighVoltage::Routes.draw(map)
end
