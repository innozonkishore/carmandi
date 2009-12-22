class CreateVehicles < ActiveRecord::Migration
  def self.up
    create_table :vehicles do |t|
      t.string :status, :default => "active"
      t.string :vin, :make_year, :fuel, :doors, :interior_color, :exterior_color
      t.text :vin_data, :dealer_comment
      t.boolean :clearance_center, :default => false
      t.float :mileage, :price
      t.integer :dealer_id, :vehicle_make_id, :vehicle_model_id, :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :vehicles
  end
end
