namespace :db do
  desc "Create and initialize default categories, vehicle_type, vehicle_make, vehicle_model, roles and admin"
  task :initialize => :environment do
   
    Rake::Task[ "data:roles" ].invoke
    Rake::Task[ "data:admin" ].invoke
    Rake::Task[ "data:make_model" ].invoke
    # Rake::Task[ "data:vehicle_type" ].invoke
    Rake::Task[ "data:categories" ].invoke
    Rake::Task[ "data:ad_location" ].invoke
    
  end
end