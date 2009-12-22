class CreateCategoryPhotos < ActiveRecord::Migration
  def self.up
    create_table :category_photos do |t|
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "parent_id"
    t.string   "height"
    t.string   "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "width"      

    end
  end

  def self.down
    drop_table :category_photos
  end
end
