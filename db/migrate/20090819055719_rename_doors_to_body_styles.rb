class RenameDoorsToBodyStyles < ActiveRecord::Migration
  def self.up
    rename_column :vehicles, :doors, :body_styles
  end

  def self.down
    rename_column :vehicles, :body_styles, :doors
  end
end
