require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module AdLocationSpecHelper
  def valid_ad_location_attributes
    { :name => 'leftbar_home1',
      :ad_id => 1 }
  end
end

describe 'Each ad location' do
  include AdLocationSpecHelper
  fixtures :ads, :ad_locations, :ad_images


  it 'must invalidate without a name' do
    AdLocation.should need(:name).using(valid_ad_location_attributes)
  end
  
  it 'must have a unique name' do
    AdLocation.should need(:name).to_be_unique.using(valid_ad_location_attributes)
  end
  
  it 'could display a single ad' do
    AdLocation.should belong_to(:ad)
  end
  
  it "should have a method 'leftbar_ad' which returns default ad if no ad is specified for that location" do
    AdLocation.leftbar_ad('leftbar_private_sales').should eql(["1", "/images/ads/8.png"])
  end
  
  it "should have a method 'leftbar_ad' which returns code ad if associated ad is HTML/JS code" do
    AdLocation.leftbar_ad('leftbar_home').should eql(["0", nil])
  end
  
  it "should have a method 'leftbar_ad' which returns image ad if associated ad is image" do
    AdLocation.leftbar_ad('leftbar_new_car').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif", nil])
  end
  
  it "should have a method 'leftbar_ad' which returns image ad if associated ad is image without url" do
    AdLocation.leftbar_ad('leftbar_clearance_center').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif"])
  end
  
  it "should have a method 'rightbar_ad' which returns default ad if no ad is specified for that location" do
    AdLocation.rightbar_ad('rightbar_private_sales').should eql(["1", "/images/ads/8.png"])
  end
  
  it "should have a method 'rightbar_ad' which returns code ad if associated ad is HTML/JS code" do
    AdLocation.rightbar_ad('rightbar_home').should eql(["0", nil])
  end
  
  it "should have a method 'rightbar_ad' which returns image ad if associated ad is image" do
    AdLocation.rightbar_ad('rightbar_new_car').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif", nil])
  end
  
  it "should have a method 'rightbar_ad' which returns image ad if associated ad is image without url" do
    AdLocation.rightbar_ad('rightbar_clearance_center').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif"])
  end
  
  it "should have a method 'bottom_row_left_ad' which returns default ad if no ad is specified for that location" do
    AdLocation.bottom_row_left_ad('bottom_row_left_private_sales').should eql(["1", "/images/ads/1.gif"])
  end
  
  it "should have a method 'bottom_row_left_ad' which returns code ad if associated ad is HTML/JS code" do
    AdLocation.bottom_row_left_ad('bottom_row_left_home').should eql(["0", nil])
  end
  
  it "should have a method 'bottom_row_left_ad' which returns image ad if associated ad is image" do
    AdLocation.bottom_row_left_ad('bottom_row_left_new_car').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif", nil])
  end
  
  it "should have a method 'bottom_row_left_ad' which returns image ad if associated ad is image without url" do
    AdLocation.bottom_row_left_ad('bottom_row_left_clearance_center').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif"])
  end
  
  it "should have a method 'bottom_row_middle_ad' which returns default ad if no ad is specified for that location" do
    AdLocation.bottom_row_middle_ad('bottom_row_middle_private_sales').should eql(["1", "/images/ads/2.jpg"])
  end
  
  it "should have a method 'bottom_row_middle_ad' which returns code ad if associated ad is HTML/JS code" do
    AdLocation.bottom_row_middle_ad('bottom_row_middle_home').should eql(["0", nil])
  end
  
  it "should have a method 'bottom_row_middle_ad' which returns image ad if associated ad is image" do
    AdLocation.bottom_row_middle_ad('bottom_row_middle_new_car').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif", nil])
  end
  
  it "should have a method 'bottom_row_middle_ad' which returns image ad if associated ad is image without url" do
    AdLocation.bottom_row_middle_ad('bottom_row_middle_clearance_center').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif"])
  end
  
  it "should have a method 'bottom_row_right_ad' which returns default ad if no ad is specified for that location" do
    AdLocation.bottom_row_right_ad('bottom_row_right_private_sales').should eql(["1", "/images/ads/3.gif"])
  end
  
  it "should have a method 'bottom_row_right_ad' which returns code ad if associated ad is HTML/JS code" do
    AdLocation.bottom_row_right_ad('bottom_row_right_home').should eql(["0", nil])
  end
  
  it "should have a method 'bottom_row_right_ad' which returns image ad if associated ad is image" do
    AdLocation.bottom_row_right_ad('bottom_row_right_new_car').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif", nil])
  end
  
  it "should have a method 'bottom_row_right_ad' which returns image ad if associated ad is image without url" do
    AdLocation.bottom_row_right_ad('bottom_row_right_clearance_center').should eql(["1", "/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/ad_images/0000/0001/130x80_hdfc_20feb.gif"])
  end
  
  it "should have a method 'center_ad' which returns default ad if no ad is specified for that location" do
    AdLocation.center_ad.should eql(["0", nil])
  end
  
  
  
end
