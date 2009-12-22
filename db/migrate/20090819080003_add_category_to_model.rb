class AddCategoryToModel < ActiveRecord::Migration
  def self.up
    add_column :vehicle_models, :category_id, :integer
    remove_column :vehicle_models, :url
  end

  def self.down
    remove_column :vehicle_models, :category_id
    add_column :vehicle_models, :url, :string
  end
end
