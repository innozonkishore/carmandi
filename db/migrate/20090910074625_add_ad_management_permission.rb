class AddAdManagementPermission < ActiveRecord::Migration
  def self.up
    add_column :permissions, :manage_ad, :boolean
  end

  def self.down
    remove_column :permissions, :manage_ad
  end
end
