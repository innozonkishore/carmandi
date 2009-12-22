class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :filename, :thumbnail, :content_type, :name
      t.integer :height, :width, :size, :parent_id
      t.references :attachable, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
