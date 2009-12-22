namespace :data do
  desc "This adds default vehicle_types in database"
  task :vehicle_type => :environment do
    
    [{:name => 'Car'},
     {:name => 'Truck'},
     {:name => 'Jeep'}].each do |vehicle_type|
      new_vehicle_type = VehicleType.new(vehicle_type)
      if new_vehicle_type.save
        puts I18n.translate(:vehicle_type_created, :name => vehicle_type[:name])
      else
        puts I18n.translate(:vehicle_type_fail, :name => vehicle_type[:name])
      end
    end
    
  end
end