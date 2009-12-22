class AddStockNumberToVehicle < ActiveRecord::Migration
  def self.up
    add_column :vehicles, :stock_number, :string
  end

  def self.down
    remove_column :vehicles, :string
  end
end
