class PrivateVehicle < ActiveRecord::Base

  acts_as_mappable   :default_units => :kms, 
                     :default_formula => :flat, 
                     :distance_field_name => :distance,
                     :lat_column_name => :lat,
                     :lng_column_name => :lng

  before_create :save_lat_and_lng_and_others


  # STATUS = { "Active" => "active", "Inactive"=> "inactive", "Sold" => "sold", "Delete" => "delete"}
  FUEL = ["Regular Gas", "Diesel", "Premium Gas only", "Propane"]
  TRANSMISSION = ["Manual", "Automatic"]
  DRIVE = ["FWD", "RWD", "AWD", "4X4"]


  ##### Validations #####

  validates_presence_of :asking_price, :mileage, :vehicle_make_id, :model, :zipcode, :user_id
  validates_associated :photos

  ##### Associations #####

  belongs_to :vehicle_make
  belongs_to :vehicle_model
  belongs_to :category
  belongs_to :seller, :class_name => "User", :foreign_key => 'user_id'

  has_many :photos, :as => :attachable, :dependent => :destroy
  has_many :saved_vehicles, :as => :resource

  # named_scope :active, :conditions => ["status = ?", 'active']
  named_scope :active_and_inactive, :conditions => ["status = ? or status = ?", 'active', 'inactive']
  named_scope :sort, :order => ["plan DESC"]

  ##### Methods #####

  def save_lat_and_lng_and_others
    self.zipcode = seller.zipcode if zipcode == nil
    geo = Geokit::Geocoders::MultiGeocoder.geocode(zipcode)
    self.lat, self.lng = geo.lat,geo.lng if geo.success
    # self.vehicle_model.update_attribute(:category_id, self.category_id)
    self.days = 30 if self.days == nil
  end
  
  def deadline
    created_at + (self.days*86400)
  end
  
  def self.active
    active_vehicles = []
    self.sort.each do |v|
      if v.status == 'active' && v.deadline >= Time.now
        active_vehicles << v
      end
    end
    active_vehicles
  end
  
  def self.active_min_price(minimum_price)
    active_vehicles = []
    self.sort.each do |v|
      if v.status == 'active' && v.deadline >= Time.now && v.asking_price >= minimum_price
        active_vehicles << v
      end
    end
    active_vehicles
  end
  
  def self.active_and_price_range(min, max)
    active_vehicles = []
    self.sort.each do |v|
      if v.status == 'active' && v.deadline >= Time.now && v.asking_price >= min && v.asking_price <= max
        active_vehicles << v
      end
    end
    active_vehicles
  end

  
  def delete_other_photos
    all_photos = self.photos
    if all_photos.size > 1
      all_photos.first.destroy
      all_photos = self.photos.reload
      self.delete_other_photos if all_photos.size > 1
    end
  end
  
  def vehicle_thumb_image
    return "/images/no_car_image2_thumb.jpg" if photos.empty?
    photos.first.public_filename(:thumb)
  end
  
  def vehicle_main_image
    return "/images/no_car_image2.jpg" if photos.empty?
    photos.first.public_filename
  end
  
  def already_saved(user_id)
    saved = SavedVehicle.find(:first, :conditions => ["user_id = ? and resource_type = ? and resource_id = ?", user_id, self.class.name, self.id])
    if saved.nil?
      false
    else
      true
    end
  end
  
  def self.save_options(parameter)
    unless parameter.nil?
      options = ''
      parameter.each do |p|
        if options == ''
          options = p
        else
          options << ';'+p
        end
      end
      options
    end
  end

  # def prepare_optional_features(options)
  #   optional_feat = ""
  #   options.each do |key, value|
  #     if optional_feat.blank?
  #       optional_feat << value if value != '0'
  #     else
  #       new_value = (";" << value)
  #       optional_feat << new_value if value != '0'
  #     end
  #   end
  #   self.optional_features = optional_feat
  # end
  # 
  # def save_optional_features(options)
  #   self.prepare_optional_features(options)
  #   self.save
  #   # self.update_attribute(:optional_features, optional_feat)
  # end
  # 
  # def prepare_other_features(options, opt_value, valued_options)
  #   other_feat = ""
  #   options.each do |key, value|
  #     if value != '0'
  #       save_value = value + ":" + opt_value[key]
  #       if other_feat.blank?
  #         other_feat << save_value
  #       else
  #         new_value = (";" << save_value)
  #         other_feat << new_value
  #       end
  #     end
  #   end
  #   valued_options.each do |key, value|
  #     if value != '0'
  #       if other_feat.blank?
  #         other_feat << value
  #       else
  #         new_value = (";" << value)
  #         other_feat << new_value
  #       end
  #     end
  #   end
  #   self.other_features = other_feat
  # end
  # 
  # def save_other_features(options, opt_value, valued_options)
  #   self.prepare_other_features(options, opt_value, valued_options)
  #   self.save
  #   # self.update_attribute(:other_features, other_feat)
  # end
  # 
  # def create_by_admin(photo_parameter = [])
  #   if self.save
  #     #      photo_parameter.each do |photo|
  #     #        self.vehicle_photos << VehiclePhoto.new(:uploaded_data => photo)
  #     #      end if photo_parameter && photo_parameter.join != ""
  #     photos = VehiclePhoto.find photo_parameter.split(',').delete_if{|x| x.blank?}
  #     unless photos.blank?
  #       photos.each do |photo|
  #         photo.vehicle_id = self.id
  #         photo.save
  #       end
  #     end
  #     return true
  #   else
  #     return false
  #   end
  # end
  # 
  # def update_vehicle(vehicle_parameter, photo_parameter = [])
  #   if self.update_attributes(vehicle_parameter)
  #     photos = VehiclePhoto.find photo_parameter.split(',').delete_if{|x| x.blank?}
  #     unless photos.blank?
  #       photos.each do |photo|
  #         photo.vehicle_id = self.id
  #         photo.save
  #       end
  #     end
  #     return true
  #   else
  #     false
  #   end
  # end

end
