class UnsupportedVehicle < ActiveRecord::Base
  
  FUEL = ["Regular Gas", "Diesel", "Premium Gas only", "Propane"]
  TRANSMISSION = ["Manual", "Automatic"]
  DRIVE = ["FWD", "RWD", "AWD", "4X4"]
  
  ##### Validations #####

  validates_presence_of :asking_price, :mileage, :vehicle_make_id, :model, :category_id
  validates_associated :photos

  ##### Associations #####

  belongs_to :vehicle_make
  belongs_to :vehicle_model
  belongs_to :category
  belongs_to :seller, :class_name => 'User', :foreign_key => 'user_id'

  has_many :photos, :as => :attachable
  
  ##### Methods #####
  
  def delete_other_photos
    all_photos = self.photos
    if all_photos.size > 1
      all_photos.first.destroy
      all_photos = self.photos.reload
      self.delete_other_photos if all_photos.size > 1
    end
  end
  
  def vehicle_thumb_image
    return "/images/no_car_image2.jpg" if photos.empty?
    photos.first.public_filename(:thumb)
  end
  
  # def save_options(parameters)
  #   parameters.each do |p|
  #     if options == ''
  #       self.options = p
  #     else
  #       self.options << ';'+p
  #     end
  #   end
  #   # self.save
  # end
  
end
