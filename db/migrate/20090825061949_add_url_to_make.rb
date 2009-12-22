class AddUrlToMake < ActiveRecord::Migration
  def self.up
    add_column :vehicle_makes, :url, :string
  end

  def self.down
    remove_column :vehicle_makes, :url
  end
end
