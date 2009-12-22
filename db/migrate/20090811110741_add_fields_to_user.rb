class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :address, :string
    add_column :users, :phone_number, :string
    add_column :users, :active, :boolean, :default => true
  end

  def self.down
    remove_column :users, :address
    remove_column :users, :phone_number
    remove_column :users, :active
  end
end
