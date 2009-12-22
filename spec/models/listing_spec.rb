require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ListingSpecHelper
  def valid_listing_attributes
    { :name => 'first listing' }
  end
end

describe Listing do
  include ListingSpecHelper
  fixtures :listings, :links, :photos
  
  before do
    @useful_listing = listings(:useful_listing)
    @important_listing = listings(:important_listing)
  end

  it "must invalidate without a name" do
    Listing.should need(:name).using(valid_listing_attributes)
  end

  it "should be associated with a link" do
    Listing.should belong_to(:link)
  end
  
  it "should have one associated photo" do
    Listing.should have_one(:photo).with_options(:as => :attachable, :dependent => :destroy)
  end
  
  it "may have one associated coupon" do
    Listing.should have_one(:coupon).with_options(:as => :attachable, :dependent => :destroy)
  end

  it "has a named_scope method 'active' which returns all active listings" do
    Listing.active.size.should eql(1)
  end
  
  it "has a named_scope method 'active_and_inactive' which returns all listings which are active or inactive" do
    Listing.active_and_inactive.size.should eql(2)
  end
  
  it "should have a method 'main_photo' which returns its associated photo" do
    @useful_listing.main_photo.should eql("no_image_available.jpg")
    @important_listing.main_photo.should eql("/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/photos/2460/4495/130x80_hdfc_20feb_thumb.gif")
  end
  
  it "should have a method 'save_display_options' which returns all teh display options in proper format" do
    @useful_listing.save_display_options("a" => "0", "b" => "save", "c" => "this").should eql("save;this")
  end
  
  it "should have a method 'display?' which returns true if passed-in option must be displayed else returns false" do
    @useful_listing.display?('anything').should eql(false)
    @important_listing.display?('description').should eql(true)
    @important_listing.display?('anything').should eql(false)
  end
  
end
