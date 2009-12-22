require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VehicleTrimType do

  it "should be associated with vehicles" do
    VehicleTrimType.should have_many(:vehicles)
  end
  
  
end
