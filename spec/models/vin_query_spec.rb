require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VinQuery do
  
  def valid_vin_attributes
    { :vin => 'ABCD',
      :vin_data => 'Description of vehicle' }
  end

  it 'must invalidate without a vin' do
    VinQuery.should need(:vin).using(valid_vin_attributes)
  end
  
  it 'should have a unique vin' do
    VinQuery.should need(:vin).to_be_unique.using(valid_vin_attributes)
  end
  
  it 'must have vin data associated to that vin' do
    VinQuery.should need(:vin_data).using(valid_vin_attributes)
  end

end
