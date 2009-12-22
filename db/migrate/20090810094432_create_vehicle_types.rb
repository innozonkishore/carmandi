class CreateVehicleTypes < ActiveRecord::Migration
  def self.up
    create_table :vehicle_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :vehicle_types
  end
end
