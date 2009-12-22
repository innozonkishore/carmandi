require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module DealerSpecHelper
  def valid_dealer_attributes
    { :dealership_name => 'my first dealer',
      :city => 'kryptocrat',
      :province => 'krypton',
      :phone_number => '0000000',
      :address => 'superman ka ghar hai bhai',
      :postal_code => '0101010',
      :upload_limit => 100 }
  end
end

describe 'Each dealer' do
  include DealerSpecHelper
  fixtures :dealers, :users
  
  # before do
  #   @category = categories(:household)
  # end

  it 'must invalidate without a dealership name' do
    Dealer.should need(:dealership_name).using(valid_dealer_attributes)
  end
  
  it 'must invalidate without a city' do
    Dealer.should need(:city).using(valid_dealer_attributes)
  end
  
  it 'must invalidate without a province' do
    Dealer.should need(:province).using(valid_dealer_attributes)
  end
  
  it 'must invalidate without a phone number' do
    Dealer.should need(:phone_number).using(valid_dealer_attributes)
  end
  
  it 'must invalidate without an address' do
    Dealer.should need(:address).using(valid_dealer_attributes)
  end
  
  it "must have numeric upload limit" do
    Dealer.should need(:upload_limit).to_be_numeric.using(valid_dealer_attributes)
  end
  
  it "should belong to a user" do
    Dealer.should belong_to(:user)
  end
  
  it "has one associated logo" do
    Dealer.should have_one(:dealer_logo).with_options(:as => :attachable, :dependent => :destroy)
  end
  
  it "has one associated coupon" do
    Dealer.should have_one(:coupon).with_options(:as => :attachable, :dependent => :destroy)
  end
  
  it "could upload many vehicles" do
    Dealer.should have_many(:vehicles).with_options(:dependent => :destroy)
  end
  
  it "has a method 'active' which returns all the active dealers" do
    Dealer.active.size.should eql(1)
  end
  
end
