class CreateDealerLogos < ActiveRecord::Migration
  def self.up
    create_table :dealer_logos do |t|
      t.string :filename, :thumbnail, :content_type
      t.integer :height, :width, :size, :parent_id
      t.references :attachable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :dealer_logos
  end
end
