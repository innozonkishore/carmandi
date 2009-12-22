class AddPhoneNumberToDealer < ActiveRecord::Migration
  def self.up
    add_column :dealers, :phone_number, :string
  end

  def self.down
    remove_column :dealers, :phone_number
    
  end
end
