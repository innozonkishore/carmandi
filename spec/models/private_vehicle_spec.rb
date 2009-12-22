require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module PrivateVehicleSpecHelper
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

describe PrivateVehicle do
  include PrivateVehicleSpecHelper
  fixtures :private_vehicles, :photos, :categories, :dealers, :vehicle_makes, :vehicle_models, :users
  
  before do
    @vehicle = private_vehicles(:private_vehicle1)
  end

  it "must invalidate without a asking price" do
    PrivateVehicle.should need(:asking_price).using(valid_vehicle_attributes)
  end
  
  it "must invalidate without a mileage" do
    PrivateVehicle.should need(:mileage).using(valid_vehicle_attributes)
  end
  
  it "must invalidate without a vehicle_makes_id" do
    PrivateVehicle.should need(:vehicle_make_id).using(valid_vehicle_attributes)
  end
  
  it "must invalidate without a vehicle model" do
    PrivateVehicle.should need(:model).using(valid_vehicle_attributes)
  end
  
  it "must invalidate without a postal code" do
    PrivateVehicle.should need(:zipcode).using(valid_vehicle_attributes)
  end
  
  it "must invalidate without associated user" do
    PrivateVehicle.should need(:user_id).using(valid_vehicle_attributes)
  end
  
  it "should have many associated photos" do
    PrivateVehicle.should have_many(:photos).with_options(:as => :attachable, :dependent => :destroy)
  end
  
  it "should be saved in search history of a registered buyer" do
    PrivateVehicle.should have_many(:saved_vehicles).with_options(:as => :resource)
  end
  
  it "should belong to make" do
    PrivateVehicle.should belong_to(:vehicle_make)
  end
  
  it "should belong to model" do
    PrivateVehicle.should belong_to(:vehicle_model)
  end
  
  it "should belong to category" do
    PrivateVehicle.should belong_to(:category)
  end
  
  it "should belong to a user" do
    PrivateVehicle.should belong_to(:seller).with_options(:class_name => "User", :foreign_key => 'user_id')
  end
  
  it "should have a method 'sort' which returns all the vehicles in sorted(by plan) order" do
    PrivateVehicle.sort.size.should eql(1)
  end
  
  it "should have a method 'save_lat_and_lng_and_others' which saves latitude and longitude before creating a new private vehicle" do
    @vehicle = PrivateVehicle.new
    @vehicle.attributes = valid_vehicle_attributes
    @vehicle.days = nil
    @vehicle.save.should eql(true)
  end
  
  it "should have a method 'active_and_inactive' which returns all the active vehicles" do
    PrivateVehicle.active_and_inactive.size.should eql(1)
  end
  
  it "should have a method 'deadline' which returns the expiration date of that vehicle's ad" do
    @vehicle.created_at = Time.now
    @vehicle.save
    @vehicle.deadline.should eql(@vehicle.created_at + (@vehicle.days*86400))
  end
  
  it "should have a method 'active' which returns all active private vehicles sorted by plan" do
    PrivateVehicle.active.size.should eql(1)
  end
  
  it "should have a method 'active_min_price' which returns all active private vehicles sorted by plan and whose asking price is greater than min price" do
    PrivateVehicle.active_min_price(2500).size.should eql(1)
    PrivateVehicle.active_min_price(26000).size.should eql(0)
  end
  
  it "should have a method 'active_and_price_range' which returns all active private vehicles sorted by plan and whose asking price is between the given range" do
    PrivateVehicle.active_and_price_range(2500, 30000).size.should eql(1)
    PrivateVehicle.active_and_price_range(50000,60000).size.should eql(0)
  end
  
  it "should have a method 'delete_other_photos' which deletes unwanted photos" do
    @vehicle.photos << @vehicle.photos
    @vehicle.delete_other_photos.should eql(nil)
  end
  
  it "should have a method 'vehicle_thumb_image' which returns the thumbnail of the associated image" do
    vehicle = PrivateVehicle.new(valid_vehicle_attributes)
    vehicle.vehicle_thumb_image.should eql("/images/no_car_image2_thumb.jpg")
    @vehicle.vehicle_thumb_image.should eql('/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/photos/1630/5326/130x80_hdfc_20feb_thumb.gif')
  end
  
  it "should have a method 'vehicle_main_image' which returns the associated image" do
    vehicle = PrivateVehicle.new(valid_vehicle_attributes)
    vehicle.vehicle_main_image.should eql("/images/no_car_image2.jpg")
    @vehicle.vehicle_main_image.should eql('/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/photos/1630/5326/130x80_hdfc_20feb.gif')
  end
  
  it "should have a method 'already_saved' which returns true if the displayed private vehicle is saved in search history of current user else returns false" do
    @vehicle.already_saved(users(:representative).id).should eql(false)
  end
  
  it "should have a method 'save_options' which saves the optional features in a proper format" do
    PrivateVehicle.save_options(["a","b","c"]).should eql("a;b;c")
  end
  
end
