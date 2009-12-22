class AddPlanToPrivateVehicle < ActiveRecord::Migration
  def self.up
    add_column :private_vehicles, :plan, :string
    add_column :unsupported_vehicles, :plan, :string
  end

  def self.down
    remove_column :private_vehicles, :plan
    remove_column :unsupported_vehicles, :plan
  end
end
