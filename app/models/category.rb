# == Schema Information
# Schema version: 20090811110741
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name, :unless => Proc.new {|n| n.name.blank?}
  
  has_many :vehicles
  has_many :vehicle_models
  has_one :category_photo, :dependent => :destroy
  
  attr_accessor :picture
  
  
  def after_save
    if self.picture and self.category_photo.nil? 
      
      self.create_category_photo(:uploaded_data => picture)
      
    elsif self.picture and !self.category_photo.nil? 
      self.category_photo.uploaded_data = picture
      self.category_photo.save
    end
  end
  
  def before_destroy
    vehicles = Vehicle.find(:all, :conditions => ["category_id = ?", self.id])
    vehicles.each do |v|
      v.category_id = Category.first.id
      v.save
    end
  end
  
  def self.general
    Category.find_by_name("General") rescue Category.first
  end

  def thumb
    if category_photo
      category_photo.public_filename(:thumb)
    else
      "car_van.png"
    end
  end
  
end
