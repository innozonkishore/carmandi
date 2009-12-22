class AddPostalCodeToDealer < ActiveRecord::Migration
  def self.up
    add_column :dealers, :postal_code, :string
  end

  def self.down
    remove_column :dealers, :postal_code
  end
end
