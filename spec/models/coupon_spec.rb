require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Coupon do
  it "could belong to a dealer or listing" do
    Coupon.should belong_to(:attachable).with_options(:foreign_type=>"attachable_type", :polymorphic => true)
  end
  
  it "should save the associated images of private vehicle or listing" do
    Coupon.should respond_to(:image?)
  end
end
