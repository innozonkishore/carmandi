class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.boolean :category, :vehicle_make, :vehicle_model, :vehicle_type, :create_dealer, :modify_dealer
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
