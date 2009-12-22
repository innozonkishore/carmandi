require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CategoryPhoto do

  it "should belong to a category" do
    CategoryPhoto.should belong_to(:category)
  end
  
  it "should save the associated images of category" do
    CategoryPhoto.should respond_to(:image?)
  end
  
end
