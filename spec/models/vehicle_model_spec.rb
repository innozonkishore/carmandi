require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VehicleModel do
  
  def valid_vehicle_model_attributes
    { :name => '800' }
  end

  it "should invalidate without name" do
    VehicleModel.should need(:name).using(valid_vehicle_model_attributes)
  end
  
  it "should have a unique name" do
    VehicleModel.should need(:name).to_be_unique.using(valid_vehicle_model_attributes)
  end
  
  it "should have many vehicles" do
    VehicleModel.should have_many(:vehicles)
  end
  
  it "should belong to a vehicle make" do
    VehicleModel.should belong_to(:vehicle_make)
  end
  
  it "should be associated with a category" do
    VehicleModel.should belong_to(:category)
  end

end
