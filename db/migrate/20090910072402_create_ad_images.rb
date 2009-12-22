class CreateAdImages < ActiveRecord::Migration
  def self.up
    create_table :ad_images do |t|
      t.string :filename, :thumbnail, :content_type
      t.integer :height, :width, :size, :parent_id, :ad_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ad_images
  end
end
