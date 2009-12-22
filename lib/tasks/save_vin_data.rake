namespace :data do
  desc "Saves the vin data of all the existing vehicles along with their vin number"
  task :save_vin_data => :environment do
   
    Vehicle.find(:all).each do |vehicle|
      existing = VinQuery.find_by_vin(vehicle.vin)
      unless existing
        vinquery = VinQuery.new(:vin => vehicle.vin, :vin_data => vehicle.vin_data)
        if vinquery.save
          puts "Vinquery with vin number: #{vehicle.vin} saved successfully"
        else
          puts "Failed to save data of vin number: #{vehicle.vin}"
        end
      end
    end
      
  end
end