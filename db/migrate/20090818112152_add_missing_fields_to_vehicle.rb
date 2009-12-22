class AddMissingFieldsToVehicle < ActiveRecord::Migration
  def self.up
    add_column :vehicles, :trim, :string
    add_column :vehicles, :model_year, :integer
  end

  def self.down
    remove_column :vehicles, :model_year
    remove_column :vehicles, :trim
  end
end
