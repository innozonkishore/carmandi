class CreateSavedVehicles < ActiveRecord::Migration
  def self.up
    create_table :saved_vehicles do |t|
      t.integer :user_id
      t.references :resource, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :saved_vehicles
  end
end
