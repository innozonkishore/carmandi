class AddLinkPermission < ActiveRecord::Migration
  def self.up
    add_column :permissions, :add_link, :boolean, :default => true
    add_column :permissions, :add_listing, :boolean
  end

  def self.down
    remove_column :permissions, :add_link
    remove_column :permissions, :add_listing
  end
end
