class AddVehiclePermissions < ActiveRecord::Migration
  def self.up
    add_column :permissions, :upload_vehicle, :boolean
    add_column :permissions, :modify_vehicle, :boolean
    add_column :permissions, :view_vehicle_list, :boolean
  end

  def self.down
    remove_column :permissions, :upload_vehicle
    remove_column :permissions, :modify_vehicle
    remove_column :permissions, :view_vehicle_list
  end
end
