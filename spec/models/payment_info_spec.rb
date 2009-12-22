require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaymentInfo do

  def valid_payment_info
    { :firstname => 'arun',
      :middlename => 'kumar',
      :lastname => 'srivastava',
      :address => 'meri gali',
      :city => 'Mumbai',
      :state => 'Maharashtra',
      :postal_code => '94106'
      }
  end

  it "should invalidate wihtout firstname" do
    PaymentInfo.should need(:firstname).using(valid_payment_info)
  end
  
  it "should invalidate without lastname" do
    PaymentInfo.should need(:lastname).using(valid_payment_info)
  end
  
  it "should invalidate without address" do
    PaymentInfo.should need(:address).using(valid_payment_info)
  end
  
  it "should invalidate without city" do
    PaymentInfo.should need(:city).using(valid_payment_info)
  end
  
  it "should invalidate without state" do
    PaymentInfo.should need(:state).using(valid_payment_info)
  end

end
