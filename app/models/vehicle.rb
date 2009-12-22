class Vehicle < ActiveRecord::Base
  
  acts_as_mappable   :default_units => :kms, 
                     :default_formula => :flat, 
                     :distance_field_name => :distance,
                     :lat_column_name => :lat,
                     :lng_column_name => :lng
                     
  before_create :save_lat_and_lng_and_others
  
  
  STATUS = { "Active" => "active", "Inactive"=> "inactive", "Sold" => "sold", "Delete" => "delete"}
  FUEL = ["Regular Gas", "Diesel", "Premium Gas only", "Propane"]
  
  cattr_reader :per_page
  @@per_page = PER_PAGE
  
  
  ##### Validations #####
  
  validates_presence_of :dealer_id, :status, :vin, :body_styles, :price, :mileage, :trim, :vehicle_make_id, :vehicle_model_id, :category_id
  validates_associated :vehicle_photos
  
  ##### Associations #####
  
  belongs_to :vehicle_make
  belongs_to :vehicle_model
  belongs_to :category
  belongs_to :dealer
#  belongs_to :vehicle_trim_type
  
  has_many :vehicle_photos, :dependent => :destroy
  has_many :saved_vehicles, :as => :resource
  
  named_scope :active, :conditions => ["status = ?", 'active']
  named_scope :active_and_inactive, :conditions => ["status = ? or status = ?", 'active', 'inactive']
  
  ##### Methods #####
  
  def save_lat_and_lng_and_others
    self.zipcode = dealer.postal_code if self.zipcode.blank? #dealer.user.zipcode
    geo = Geokit::Geocoders::MultiGeocoder.geocode(zipcode)
    # errors.add(:zipcode, "Could not be decoded") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
    self.vehicle_model.update_attribute(:category_id, self.category_id)
  end
  
  # def find_distance(location)
  #   distance = self.distance_from(location) rescue nil
  #   return '0' if distance.nil?
  #   "%.2f" %"#{distance}"
  # end
  
  def prepare_optional_features(options)
    optional_feat = ""
    options.each do |key, value|
      if optional_feat.blank?
        optional_feat << value if value != '0'
      else
        new_value = (";" << value)
        optional_feat << new_value if value != '0'
      end
    end
    self.optional_features = optional_feat
  end
  
  def save_optional_features(options)
    self.prepare_optional_features(options)
    self.save
    # self.update_attribute(:optional_features, optional_feat)
  end
  
  def prepare_other_features(options, opt_value, valued_options)
    other_feat = ""
    options.each do |key, value|
      if value != '0'
        save_value = value + ":" + opt_value[key]
        if other_feat.blank?
          other_feat << save_value
        else
          new_value = (";" << save_value)
          other_feat << new_value
        end
      end
    end
    valued_options.each do |key, value|
      if value != '0'
        if other_feat.blank?
          other_feat << value
        else
          new_value = (";" << value)
          other_feat << new_value
        end
      end
    end
    self.other_features = other_feat
  end
  
  def save_other_features(options, opt_value, valued_options)
    self.prepare_other_features(options, opt_value, valued_options)
    self.save
    # self.update_attribute(:other_features, other_feat)
  end
  
  def comma_separated_optional_features
    of = ""
    op_features = optional_features
    return of if op_features.blank?
    opt_features = op_features.split(";")
    opt_features.each do |op|
      if of.blank?
        of << op
      else
        of << ("," << op)
      end
    end
    of
  end
  
  def vehicle_thumb_image
    return "/images/no_image.gif" if vehicle_photos.empty?
    vehicle_photos.first.public_filename(:thumb)
  end
  
  def vehicle_main_image
    return "/images/no_image.gif" if vehicle_photos.empty?
    vehicle_photos.first.public_filename
  end
  
  def create_by_admin(photo_parameter = [])
    if self.save
#      photo_parameter.each do |photo|
#        self.vehicle_photos << VehiclePhoto.new(:uploaded_data => photo)
#      end if photo_parameter && photo_parameter.join != ""
      photos = VehiclePhoto.find photo_parameter.split(',').delete_if{|x| x.blank?}
      unless photos.blank?
        photos.each do |photo|
          photo.vehicle_id = self.id
          photo.save
        end
      end
      return true
    else
      return false
    end
  end
  
  def update_vehicle(vehicle_parameter, photo_parameter = [])
    if self.update_attributes(vehicle_parameter)
      photos = VehiclePhoto.find photo_parameter.split(',').delete_if{|x| x.blank?}
      unless photos.blank?
        photos.each do |photo|
          photo.vehicle_id = self.id
          photo.save
        end
      end
      return true
    else
      false
    end
  end
  
  def already_saved(user_id)
    saved = SavedVehicle.find(:first, :conditions => ["user_id = ? and resource_type = ? and resource_id = ?", user_id, self.class.name, self.id])
    if saved.nil?
      false
    else
      true
    end
  end
  
  # def update_from_admin_section(vehicle_parameter, photo_parameter = nil)
  #   if self.update_attributes(vehicle_parameter)
  #     photo_parameter.each do |photo|
  #       self.vehicle_photos << VehiclePhoto.new(:uploaded_data => photo)
  #     end if photo_parameter && photo_parameter.join != ""
  #     return true
  #   else
  #     false
  #   end
  # end
  
end
