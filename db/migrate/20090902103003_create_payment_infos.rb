class CreatePaymentInfos < ActiveRecord::Migration
  def self.up
    create_table :payment_infos do |t|
      t.string :firstname, :middlename, :lastname, :address, :city, :state, :postal_code
      t.float :price_option
      t.integer :vehicle_id, :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :payment_infos
  end
end
