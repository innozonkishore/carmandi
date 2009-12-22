class AddVehicleOptions < ActiveRecord::Migration
  def self.up
    add_column :private_vehicles, :options, :text
    add_column :unsupported_vehicles, :options, :text
  end

  def self.down
    remove_column :private_vehicles, :options
    remove_column :unsupported_vehicles, :options
  end
end
