class AddVehicleTrimTypePermission < ActiveRecord::Migration
  def self.up
	add_column :permissions, :vehicle_trim_types, :boolean
  end

  def self.down
	remove_column :permissions, :vehicle_trim_types
  end
end
