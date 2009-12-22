class AddDisplayOptionToListings < ActiveRecord::Migration
  def self.up
    add_column :listings, :display_options, :text
    add_column :listings, :status, :string , :default => 'active'
    add_column :links, :status, :string, :default => 'active'
  end

  def self.down
    remove_column :listings, :display_options
    remove_column :listings, :status
    remove_column :links, :status
  end
end
