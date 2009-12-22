class CreateDealerPreferences < ActiveRecord::Migration
  def self.up
    create_table :dealers do |t|
      t.string :dealership_name, :city, :province, :postal_code, :address, :website_url
      t.boolean :account_type
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :dealers
  end
end
