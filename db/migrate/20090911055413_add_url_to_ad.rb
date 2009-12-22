class AddUrlToAd < ActiveRecord::Migration
  def self.up
    add_column :ads, :url, :string
  end

  def self.down
    remove_column :ads, :url
  end
end
