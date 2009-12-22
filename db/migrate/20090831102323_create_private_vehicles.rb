class CreatePrivateVehicles < ActiveRecord::Migration
  def self.up
    create_table :private_vehicles do |t|
      t.string :status, :default => "active"
      t.string :vin, :model_year, :fuel, :doors, :interior_color, :exterior_color, :trim, :body_style, :engine_type, :engine_displacement, :doors, :transmission, :zipcode
      t.text :vin_data, :detailed_info
      t.float :mileage, :asking_price, :lat, :lng
      t.float :amount_collected, :default => 0
      t.integer :user_id, :vehicle_make_id, :vehicle_model_id, :category_id, :days
      t.timestamps
    end
  end

  def self.down
    drop_table :private_vehicles
  end
end
