class AddVehicleFields < ActiveRecord::Migration
  def self.up
    add_column :vehicles, :lat, :float
    add_column :vehicles, :lng, :float
    add_column :vehicles, :zipcode, :string
  end

  def self.down
    remove_column :vehicles, :lat
    remove_column :vehicles, :lng
    remove_column :vehicles, :zipcode
  end
end
