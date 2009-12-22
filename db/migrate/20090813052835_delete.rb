class Delete < ActiveRecord::Migration
  def self.up
    drop_table :vehicle_types
  end

  def self.down
    create_table :vehicle_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
