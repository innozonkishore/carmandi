ActionController::Routing::Routes.draw do |map|
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
  
  map.resources :users, :collection => {:forgot => :any, :reset => :any, :my_account => :get, :uploaded_vehicles => :get, :buyer_signup => :get, :vehicle_history => :get }, :member => {:manage_ads => :get}
  map.resources :sessions
  map.resources :coupons, :collection => {:coupon_list => :get}
  map.resources :vehicles, :collection => { :update_models => :any, :destroy_photo => :any, :used_car => :get, :clearance_center => :get, :select_category => :any, :select_price => :any, :search_result => :any}, :member => { :show_by_dealer => :get, :save_history => :any}
  map.resources :private_vehicles, :collection => { :sell_your_car => :get, :start_ad => :get, :detail_info => :post, :upload_photo => :post, :review_ad => :post, :post_ad => :any, :post_ad_thankyou => :post, :search => :get, :listing => :post, :update_photo => :put }, :member => {:show_current_user_vehicle=>:get, :edit_photo=>:get, :save_history=>:any}
  map.resources :home, :collection => { :change_language => :get }
  
  
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
  map.namespace :admin do |admin|
    admin.resources :categories, :active_scaffold => true
    admin.resources :make, :active_scaffold => true
    admin.resources :models, :active_scaffold => true
    admin.resources :trim_types, :active_scaffold => true
    admin.resources :representatives, :collection => {:home => :get }, :active_scaffold => true
    admin.resources :dealers, :collection => {:search => :post}
    admin.resources :vehicles, :collection => {:search => :post, :swfupload => :post, :vin_lookup => :post}
    admin.resources :private_vehicles
    admin.resources :links, :collection => {:add_listing => :get, :new_listing => :get, :create_listing => :post, :listing_index => :get}, :member => {:edit_listing => :get, :update_listing => :post}
    admin.resources :ads, :collection => {:view_ad_location => :get, :specify_location => :get, :save_ad_location => :post}
    admin.resources :coupons, :collection => {:show_by_dealer => :get, :show_for_listing => :get }
  end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "home"

  # See how all your routes lay out with "rake routes"
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  
  map.signup  '/signup',            :controller => 'users',     :action => 'new'
  map.login   '/login',             :controller => 'sessions',  :action => 'new'
  map.logout  '/logout',            :controller => 'sessions',  :action => 'destroy'
  map.forgot  '/forgot',            :controller => 'users',     :action => 'forgot'
  map.reset   'reset',              :controller => 'users',     :action => 'reset'
  map.admin_home    '/admin_home',              :controller => 'admin/representatives', :action => 'home'
  map.car_detail    '/car_detail/:id',          :controller => 'vehicles',              :action => 'car_detail'
  map.show_by_dealer '/show_by_dealer/:id',     :controller => 'vehicles',              :action => 'show_by_dealer'
  map.links         '/links/:id',               :controller => 'admin/links',           :action => 'show'
  
  map.new_cars      '/new_cars',                :controller => 'static',                :action => 'new_cars'
  map.privacy_policy '/privacy_policy',         :controller => 'static',                :action => 'privacy_policy'
  map.contact_us     '/contact_us',             :controller => 'static',                :action => 'contact_us'
  map.about_us       '/about_us',               :controller => 'static',                :action => 'about_us'
  map.monthly_payment_calculator '/monthly_payment_calculator',   :controller => 'static',              :action => 'calculator'
  map.sell_your_car '/sell_your_car',                             :controller => 'private_vehicles',    :action => 'sell_your_car'
  map.sell_your_car_start_add '/sell_your_car/start_ad',          :controller => 'private_vehicles',    :action => 'start_ad'
  map.sell_your_car_detail_info '/sell_your_car/detail_info',     :controller => 'private_vehicles',    :action => 'detail_info'
  map.sell_your_car_upload_photo '/sell_your_car/upload_photo',   :controller => 'private_vehicles',    :action => 'upload_photo'
  map.sell_your_car_review_ad '/sell_your_car/review_ad',         :controller => 'private_vehicles',    :action => 'review_ad'
  map.sell_your_car_post_ad '/sell_your_car/post_ad',             :controller => 'private_vehicles',    :action => 'post_ad'
  map.sell_your_car_post_ad_thankyou '/sell_your_car/post_ad_thankyou', :controller => 'private_vehicles',    :action => 'post_ad_thankyou'
  
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
