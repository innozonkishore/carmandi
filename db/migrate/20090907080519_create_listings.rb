class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.string :name, :web_address, :full_address, :contact_info
      t.text :description
      t.integer :position, :default => 0
      t.integer :link_id
      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
