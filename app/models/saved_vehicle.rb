class SavedVehicle < ActiveRecord::Base

  belongs_to :user
  
  belongs_to :resource, :polymorphic => true
  
  
  ##### Methods #####
  
  def self.save_vehicle_history(user_id, vehicle_id)
    saved_vehicle = SavedVehicle.new(:user_id => user_id)
    saved_vehicle.resource_id = vehicle_id
    saved_vehicle.resource_type = "Vehicle"
    saved_vehicle.save
  end
  
  def self.save_private_vehicle_history(user_id, vehicle_id)
    saved_vehicle = SavedVehicle.new(:user_id => user_id)
    saved_vehicle.resource_id = vehicle_id
    saved_vehicle.resource_type = "PrivateVehicle"
    saved_vehicle.save
  end
  
end
