class RemoveTypePermission < ActiveRecord::Migration
  def self.up
    remove_column :permissions, :vehicle_type
  end

  def self.down
    add_column :permissions, :vehicle_type, :boolean, :default => false
  end
end
