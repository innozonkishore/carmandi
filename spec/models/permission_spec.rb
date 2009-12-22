require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module PermissionSpecHelper
  def valid_permission_attributes
    { :category => true,
      :vehicle_make => true,
      :vehicle_model => true,
      :create_dealer => true,
      :modify_dealer => true,
      :upload_vehicle => true,
      :modify_vehicle => true,
      :view_vehicle_list => true,
      :vehicle_trim_types => true,
      :add_link => true,
      :add_listing => true,
      :manage_ad => true}
  end
end

describe Permission, "Each Permission" do
  include PermissionSpecHelper

  it "should belong to a user" do
    Permission.should belong_to(:user)
  end
end
