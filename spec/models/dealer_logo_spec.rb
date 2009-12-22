require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DealerLogo do

  it "should belong to a dealer" do
    DealerLogo.should belong_to(:attachable).with_options(:foreign_type=>"attachable_type", :polymorphic => true)
  end
  
  it "should save the associated images of a dealer" do
    DealerLogo.should respond_to(:image?)
  end
end
