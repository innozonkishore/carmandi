class ChangePrivateVehicleFields < ActiveRecord::Migration
  def self.up
    remove_column :private_vehicles, :body_style
    remove_column :private_vehicles, :engine_displacement
    add_column :private_vehicles, :drive, :string
    remove_column :private_vehicles, :vehicle_model_id
    add_column :private_vehicles, :model,:string
    
    add_column :unsupported_vehicles, :drive, :string
    remove_column :unsupported_vehicles, :vehicle_model_id
    add_column :unsupported_vehicles, :model,:string
  end

  def self.down
    add_column :private_vehicles, :body_style, :string
    add_column :private_vehicles, :engine_displacement, :string
    remove_column :private_vehicles, :drive
    add_column :private_vehicles, :vehicle_model_id, :integer
    remove_column :private_vehicles, :model
    
    remove_column :unsupported_vehicles, :drive
    add_column :unsupported_vehicles, :vehicle_model_id, :integer
    remove_column :unsupported_vehicles, :model
  end
end
