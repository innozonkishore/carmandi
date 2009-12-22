class AddUsernameAndFax < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    add_column :users, :fax_number, :string
  end

  def self.down
    remove_column :users, :username
    remove_column :users, :fax_number
  end
end
