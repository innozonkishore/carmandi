class AddZipcodeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :zipcode, :string
    remove_column :dealers, :postal_code
  end

  def self.down
    remove_column :users, :zipcode
    add_column :dealers, :postal_code, :string
  end
end
