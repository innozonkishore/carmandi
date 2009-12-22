class AddGeneralCategory < ActiveRecord::Migration
  def self.up
    c = Category.create(:name => "General")
    c.save
  end

  def self.down
    c = Category.find_by_name('General')
    c.delete
  end
end
