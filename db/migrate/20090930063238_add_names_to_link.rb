class AddNamesToLink < ActiveRecord::Migration
  def self.up
    rename_column :links, :name, :name_english
    add_column :links, :name_hindi, :string
    add_column :links, :name_urdu, :string
    add_column :links, :name_punjabi, :string
  end

  def self.down
    rename_column :links, :name_english, :name
    remove_column :links, :name_hindi
    remove_column :links, :name_urdu
    remove_column :links, :name_punjabi
  end
end
