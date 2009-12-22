class CreateVinQueries < ActiveRecord::Migration
  def self.up
    create_table :vin_queries do |t|
      t.string :vin
      t.text :vin_data
      t.timestamps
    end
  end

  def self.down
    drop_table :vin_queries
  end
end
