class AddUploadLimit < ActiveRecord::Migration
  def self.up
    add_column :dealers, :upload_limit, :integer
  end

  def self.down
    remove_column :dealers, :upload_limit
  end
end
