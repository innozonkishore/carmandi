require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VehiclePhoto do

  it "should belong to a vehicle" do
    VehiclePhoto.should belong_to(:vehicle)
  end
  
  it "should save the associated images of a vehicle" do
    VehiclePhoto.should respond_to(:image?)
  end
end
