class CreateVehicleTrimTypes < ActiveRecord::Migration
  def self.up
    create_table :vehicle_trim_types do |t|
      t.string :trim_type
      t.timestamps
    end
  end

  def self.down
    drop_table :vehicle_trim_types
  end
end
