require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdImage do
  fixtures :ad_images
  
  before do
    @ad_image = ad_images(:main_image)
  end
  
  it "should belong to an ad" do
    AdImage.should belong_to(:ad)
  end
  
  it "should save the associated images of an ad" do
    AdImage.should respond_to(:image?)
  end
end
