class AddFaltuFieldsFromVehicle < ActiveRecord::Migration
  def self.up
    remove_column :vehicles, :make_year
  end

  def self.down
    add_column :vehicles, :make_year, :string
  end
end
