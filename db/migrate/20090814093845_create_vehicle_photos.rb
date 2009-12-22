class CreateVehiclePhotos < ActiveRecord::Migration
  def self.up
    create_table :vehicle_photos do |t|
      t.string :filename, :thumbnail, :content_type
      t.integer :height, :width, :size, :parent_id, :vehicle_id
      t.timestamps
    end
  end

  def self.down
    drop_table :vehicle_photos
  end
end
