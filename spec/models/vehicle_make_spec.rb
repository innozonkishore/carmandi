require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VehicleMake do

  def valid_vehicle_make_attribute
    { :name => 'Ford', :url => 'fordmotors.com' }
  end
  
  it "should invalidate without name" do
    VehicleMake.should need(:name).using(valid_vehicle_make_attribute)
  end
  
  it "should have a unique name" do
    VehicleMake.should need(:name).to_be_unique.using(valid_vehicle_make_attribute)
  end
  
  it "should have many vehicles" do
    VehicleMake.should have_many(:vehicles)
  end
  
  it "should have many models" do
    VehicleMake.should have_many(:vehicle_models).with_options(:dependent => :destroy)
  end
  
end
