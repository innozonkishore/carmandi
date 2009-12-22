class AddStatusToCoupon < ActiveRecord::Migration
  def self.up
    add_column :coupons, :status, :string, :default => 'active'
    add_column :coupons, :primary_display, :boolean, :default => false
  end

  def self.down
    remove_column :coupons, :status
    remove_column :coupons, :primary_display
  end
end
