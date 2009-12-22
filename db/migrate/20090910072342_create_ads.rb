class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.string :ad_name, :advertiser_name, :phone_number, :email, :ad_type
      t.text :comments, :code
      t.boolean :status, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :ads
  end
end
