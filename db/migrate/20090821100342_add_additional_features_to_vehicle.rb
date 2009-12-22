class AddAdditionalFeaturesToVehicle < ActiveRecord::Migration
  def self.up
    add_column :vehicles, :standard_features, :text
    add_column :vehicles, :optional_features, :text
    add_column :vehicles, :other_features, :text
  end

  def self.down
    remove_column :vehicles, :standard_features
    remove_column :vehicles, :optional_features
    remove_column :vehicles, :other_features
  end
end
