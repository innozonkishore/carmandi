require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vehicle do
  fixtures :vehicles, :vehicle_photos, :categories, :dealers, :vehicle_makes, :vehicle_models, :users, :saved_vehicles
  
  def valid_vehicle_attributes
    {
      :status=> 'active',
      :vin=> '1HDLJOIE4743JGHD',
      :fuel=> 'Diesel',
      :body_styles=>'COUPE 2-DR',
      :vin_data=>'NULL',
      :dealer_comment=>'NULL',
      :clearance_center=>false,
      :mileage=>18,
      :price=>25000,
      :dealer_id=>1,
      :vehicle_make_id=>1,
      :vehicle_model_id=>1,
      :category_id=>Category.general.id,
      :vehicle_trim_type_id=>'NULL',
      :trim=>'Coupe',
      :model_year=>2004,
      :zipcode=>'K1A0B1'
    }
  end
  
  before(:each) do
    @vehicle = vehicles(:vehicle1)
  end
  
  it "should invalidate without vin" do
    Vehicle.should need(:vin).using(valid_vehicle_attributes)
  end
  
  it "should be associated with a dealer or user" do
    Vehicle.should need(:dealer_id).using(valid_vehicle_attributes)
  end
  
  it "should invalidate without body_styles" do
    Vehicle.should need(:body_styles).using(valid_vehicle_attributes)
  end
  
  it "should invalidate without price" do
    Vehicle.should need(:price).using(valid_vehicle_attributes)
  end
  
  it "should invalidate without mileage" do
    Vehicle.should need(:mileage).using(valid_vehicle_attributes)
  end
  
  it "should invalidate without trim" do
    Vehicle.should need(:trim).using(valid_vehicle_attributes)
  end
  
  it "should invalidate without associated make" do
    Vehicle.should need(:vehicle_make_id).using(valid_vehicle_attributes)
  end
  
  it "should invalidate without associated vehicle model" do
    Vehicle.should need(:vehicle_model_id).using(valid_vehicle_attributes)
  end
  
  it "should invalidate without associated category" do
    Vehicle.should need(:category_id).using(valid_vehicle_attributes)
  end
  
  it "should have many associated photos" do
    Vehicle.should have_many(:vehicle_photos).with_options(:dependent => :destroy)
  end
  
  it "should be saved in search history of a registered buyer" do
    Vehicle.should have_many(:saved_vehicles).with_options(:as => :resource)
  end
  
  it "should belong to make" do
    Vehicle.should belong_to(:vehicle_make)
  end
  
  it "should belong to model" do
    Vehicle.should belong_to(:vehicle_model)
  end
  
  it "should belong to category" do
    Vehicle.should belong_to(:category)
  end
  
  it "should belong to a user" do
    Vehicle.should belong_to(:dealer)
  end
  
  it "should have a method 'save_lat_and_lng_and_others' which saves latitude and longitude before creating a new vehicle" do
    @vehicle = Vehicle.new
    @vehicle.attributes = valid_vehicle_attributes
    @vehicle.vehicle_model = vehicle_models(:one)
    @vehicle.save.should eql(true)
  end
  
  it "should have a method 'active' which returns all the active vehicles" do
    Vehicle.active.size.should eql(1)
  end
  
  it "should have a method 'active_and_inactive' which returns all the active vehicles" do
    Vehicle.active_and_inactive.size.should eql(1)
  end
  
  it "should have a method 'save_optional_features' which saves all optional features in proper format" do
    @vehicle.save_optional_features("a"=>"0", "b"=>"save", "c"=>"this").should eql(true)
    @vehicle.optional_features.should eql("save;this")
  end
  
  it "should have a method 'save_other_features' which saves other features of the vehicle in a proper format" do
    a = {"11"=>"0", "6"=>"0", "12"=>"Maximum Payload", "7"=>"0", "13"=>"0", "8"=>"0", "14"=>"0", "9"=>"0", "0"=>"0", "1"=>"0", "2"=>"Height", "3"=>"0", "10"=>"0", "4"=>"0", "5"=>"0"}
    b = {"11"=>"", "6"=>"", "12"=>"50kg", "7"=>"", "13"=>"", "8"=>"", "14"=>"", "9"=>"", "0"=>"", "1"=>"", "2"=>"12in.", "3"=>"", "10"=>"", "4"=>"", "5"=>""}
    c = {"33"=>"0", "22"=>"0", "11"=>"0", "6"=>"0", "34"=>"0", "23"=>"0", "12"=>"0", "7"=>"0", "35"=>"0", "24"=>"0", "13"=>"0", "8"=>"0", "36"=>"0", "25"=>"0", "14"=>"0", "9"=>"0", "37"=>"Rust-duration:60 month", "26"=>"0", "15"=>"0", "38"=>"Rust-distance:Unlimited mile", "27"=>"0", "16"=>"0", "0"=>"0", "40"=>"0", "39"=>"0", "28"=>"0", "17"=>"0", "1"=>"0", "41"=>"0", "30"=>"0", "29"=>"0", "18"=>"0", "2"=>"0", "31"=>"0", "20"=>"0", "19"=>"0", "3"=>"0", "32"=>"0", "21"=>"0", "10"=>"0", "4"=>"0", "5"=>"0"}
    @vehicle.save_other_features(a, b, c).should eql(true)
  end
  
  it "should have a method 'comma_separated_optional_features' which returns its optional features in csv format to display alongwith the description" do
    @vehicle.comma_separated_optional_features.should eql("Subwoofer,Navigation Aid")
  end
  
  it "should have a method 'vehicle_thumb_image' which returns the thumbnail of the associated image" do
    vehicle = Vehicle.new(valid_vehicle_attributes)
    vehicle.vehicle_thumb_image.should eql("/images/no_image.gif")
    @vehicle.vehicle_thumb_image.should eql('/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/vehicle_photos/3558/7460/130x80_hdfc_20feb_thumb.gif')
  end
  
  it "should have a method 'vehicle_main_image' which returns the associated image" do
    vehicle = Vehicle.new(valid_vehicle_attributes)
    vehicle.vehicle_main_image.should eql("/images/no_image.gif")
    @vehicle.vehicle_main_image.should eql('/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/vehicle_photos/3558/7460/130x80_hdfc_20feb.gif')
  end
  
  it "should have a method 'create_by_admin' which saves the vehicle and its associated photo" do
    photo_id = vehicle_photos("main_vehicle_image").id
    @vehicle.create_by_admin("#{photo_id},").should eql(true)
    vehicle = Vehicle.new(valid_vehicle_attributes)
    vehicle.vin = ''
    vehicle.create_by_admin("#{photo_id},").should eql(false)
  end
  
  it "should have a method 'update_vehicle' which updates the vehicle and its associated photo" do
    photo_id = vehicle_photos("main_vehicle_image").id
    @vehicle.update_vehicle(@vehicle.attributes, "#{photo_id},").should eql(true)
    @vehicle.vin = ''
    @vehicle.update_vehicle(@vehicle.attributes, "#{photo_id},").should eql(false)
  end
  
  it "should have a method 'already_saved' which returns true if the displayed vehicle is saved in search history of current user else returns false" do
    @vehicle.already_saved(users(:representative).id).should eql(false)
    # @vehicle.already_saved(users(:buyer).id).should eql(true)
  end
  
end
