require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module UnsupportedVehicleSpecHelper
  def valid_vehicle_attributes
   {:status=> 'active',
    :vin=> '1HDLJOIE4743JGHD',
    :fuel=> 'Diesel',
    :vin_data=>'NULL',
    :mileage=>18,
    :asking_price=>25000,
    :user_id=>1,
    :vehicle_make_id=>1,
    :model=>'abc',
    :category_id=>Category.general.id,
    :trim=>'Coupe',
    :model_year=>2004,
    :zipcode=>'K1A0B1',
    :created_at=>Time.now }
  end
end

describe UnsupportedVehicle do
  include UnsupportedVehicleSpecHelper
  fixtures :unsupported_vehicles, :photos, :categories, :vehicle_makes, :users
  
  before do
    @vehicle = unsupported_vehicles(:unsupported_vehicle1)
  end

  it "must invalidate without a asking price" do
    UnsupportedVehicle.should need(:asking_price).using(valid_vehicle_attributes)
  end
  
  it "must invalidate without a mileage" do
    UnsupportedVehicle.should need(:mileage).using(valid_vehicle_attributes)
  end
  
  it "must invalidate without a vehicle_makes_id" do
    UnsupportedVehicle.should need(:vehicle_make_id).using(valid_vehicle_attributes)
  end
  
  it "must invalidate without a vehicle model" do
    UnsupportedVehicle.should need(:model).using(valid_vehicle_attributes)
  end
  
  it "must invalidate without a category" do
    UnsupportedVehicle.should need(:category_id).using(valid_vehicle_attributes)
  end
  
  it "should have many associated photos" do
    UnsupportedVehicle.should have_many(:photos).with_options(:as => :attachable)
  end
  
  it "should belong to make" do
    UnsupportedVehicle.should belong_to(:vehicle_make)
  end
  
  it "should belong to model" do
    UnsupportedVehicle.should belong_to(:vehicle_model)
  end
  
  it "should belong to category" do
    UnsupportedVehicle.should belong_to(:category)
  end
  
  it "should belong to a user" do
    UnsupportedVehicle.should belong_to(:seller).with_options(:class_name => "User", :foreign_key => 'user_id')
  end
 
  it "should have a method 'delete_other_photos' which deletes unwanted photos" do
    @vehicle.photos << @vehicle.photos
    @vehicle.delete_other_photos.should eql(nil)
  end
  
  it "should have a method 'vehicle_thumb_image' which returns the thumbnail of the associated image" do
    vehicle = UnsupportedVehicle.new(valid_vehicle_attributes)
    vehicle.vehicle_thumb_image.should eql("/images/no_car_image2.jpg")
    @vehicle.vehicle_thumb_image.should eql('/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/photos/7014/9672/130x80_hdfc_20feb_thumb.gif')
  end
  
  
end
