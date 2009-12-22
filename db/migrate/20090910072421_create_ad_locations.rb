class CreateAdLocations < ActiveRecord::Migration
  def self.up
    create_table :ad_locations do |t|
      t.string :name
      t.integer :ad_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ad_locations
  end
end
