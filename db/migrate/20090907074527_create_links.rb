class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :name
      t.integer :position, :default => 0
      t.boolean :useful
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
