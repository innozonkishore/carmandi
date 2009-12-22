require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Photo do
  
  it "could belong to a private vehicle or listing" do
    Photo.should belong_to(:attachable).with_options(:foreign_type=>"attachable_type", :polymorphic => true)
  end
  
  it "should save the associated images of private vehicle or listing" do
    Photo.should respond_to(:image?)
  end
end
