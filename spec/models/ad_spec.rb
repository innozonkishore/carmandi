require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module AdSpecHelper
  def valid_ad_attributes
    { :ad_name => 'automobile ad',
      :advertiser_name => 'Honda',
      :phone_number => '123567890',
      :email => 'abcd@gmail.com',
      :ad_type => 'Code' }
  end
end

describe 'Each ad' do
  include AdSpecHelper
  fixtures :ads
  
  # before do
  #   @category = categories(:household)
  # end

  it 'must invalidate without a name' do
    Ad.should need(:ad_name).using(valid_ad_attributes)
  end
  
  it 'should have a unique name' do
    Ad.should need(:ad_name).to_be_unique.using(valid_ad_attributes)
  end
  
  it 'must be of type: Code or Image' do
    Ad.should need(:ad_type).using(valid_ad_attributes)
  end
  
  it "should have one image if it is of Image type" do
    Ad.should have_one(:ad_image)
  end
  
  it "should have one ad location which tells at which location ad must be displayed" do
    Ad.should have_one(:ad_location)
  end
  
  it "should have a method 'active' which returns all active ads" do
    Ad.active.size.should eql(3)
  end
  
end
