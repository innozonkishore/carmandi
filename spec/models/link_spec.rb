require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module LinkSpecHelper
  def valid_link_attributes
    { :name_english => 'first link',
      :name_hindi => 'pehla link',
      :name_urdu => 'first link in urdu',
      :name_punjabi => 'first link in punjabi' ,
      :position => 0,
      :useful => true
      }
  end
end

describe Link do
  include LinkSpecHelper
  fixtures :links, :listings, :ad_locations
  
  before do
    @link = Link.new(valid_link_attributes)
  end

  it "must invalidate without a name in english" do
    Link.should need(:name_english).using(valid_link_attributes)
  end
  
  it "must invalidate without a name in hindi" do
    Link.should need(:name_hindi).using(valid_link_attributes)
  end
  
  it "must invalidate without a name in urdu" do
    Link.should need(:name_urdu).using(valid_link_attributes)
  end
  
  it "must invalidate without a name in punjabi" do
    Link.should need(:name_punjabi).using(valid_link_attributes)
  end
  
  # it "must have a unique name in english" do
  #   Link.should need(:name_english).to_be_unique.using(valid_link_attributes)
  # end
  # 
  # it "must have a unique name in hindi" do
  #   Link.should need(:name_hindi).to_be_unique.using(valid_link_attributes)
  # end
  # 
  # it "must have a unique name in urdu" do
  #   Link.should need(:name_urdu).to_be_unique.using(valid_link_attributes)
  # end
  # 
  # it "must have a unique name in punjabi" do
  #   Link.should need(:name_punjabi).to_be_unique.using(valid_link_attributes)
  # end
  
  it "should be associated with many listings" do
    Link.should have_many(:listings).with_options(:dependent => :destroy)
  end
  
  it "has a named_scope method 'useful' which returns all useful links" do
    Link.useful.size.should eql(2)
  end
  
  it "has a named_scope method 'useful_active' which returns all useful and active links" do
    Link.useful_active.size.should eql(1)
  end
  
  it "has a named_scope method 'important' which returns all important links" do
    Link.important.size.should eql(2)
  end
  
  it "has a named_scope method 'important_active' which returns all important and active links" do
    Link.important_active.size.should eql(1)
  end
  
  it "has a named_scope method 'active' which returns all active links" do
    Link.active.size.should eql(2)
  end
  
  it "has a named_scope method 'active_and_inactive' which returns all links which are active or inactive" do
    Link.active_and_inactive.size.should eql(4)
  end
  
  it "should have a method 'modify_ad_location' which changes the ad location name if the name of the link is changed" do
    @link.modify_ad_location('new_car', 'new_cars').should eql(["leftbar", "rightbar", "bottom_row_left", "bottom_row_middle", "bottom_row_right"])
    @link.modify_ad_location('no_existing_ad', 'no_ad').should eql(["leftbar", "rightbar", "bottom_row_left", "bottom_row_middle", "bottom_row_right"])
  end
  
  it "should have a method 'all_ad_webpages' which returns the name of all pages which can display unique ads" do
    Link.all_ad_webpages.should eql(["home", "new_car", "used_car", "clearance_center", "private_sales", "sell_your_car", "monthly_payment_calculator", "important_active", "useful_active"])
  end
  
end
