require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SavedVehicle do

  it "should belong to a user who saved it" do
    SavedVehicle.should belong_to(:user)
  end
  
  it "should be a vehicle or private vehicle" do
    SavedVehicle.should belong_to(:resource).with_options(:foreign_type=>"resource_type", :polymorphic=>true)
  end
  
  it "should have a method 'save_vehicle_history' which saves a vehicle in an user's search history" do
    SavedVehicle.save_vehicle_history(1,1).should eql(true)
  end
  
  it "should have a method 'save_private_vehicle_history' which saves a private vehicle in user's history" do
    SavedVehicle.save_private_vehicle_history(2,2).should eql(true)
  end
  
end
