class Listing < ActiveRecord::Base
  
  named_scope :active, :conditions => ["status = ?", 'active']
  named_scope :active_and_inactive, :conditions => ["status = ? or status = ?", 'active', 'inactive']
  
  ##### Validations #####
  validates_presence_of :name
  validates_associated :photo
  validates_associated :coupons
  
  ##### Associations ######
  belongs_to :link
  
  has_one :photo, :as => :attachable, :dependent => :destroy
  has_many :coupons, :as => :attachable, :dependent => :destroy
  
  ##### Methods #####
  
  def main_photo
    if photo
      photo.public_filename(:thumb)
    else
      "no_image_available.jpg"
    end
  end
  
  def primary_coupon
    coupon = Coupon.find(:first, :conditions => ["attachable_type = ? and attachable_id = ? and status = ? and primary_display = ?", 'Listing', self.id, 'active', true])
    return coupon if coupon
    coupons.first
  end

  def save_display_options(options)
    display_option = ''
    options.each do |key, value|
      if value != '0'
        if display_option.blank?
          display_option << value
        else
          new_value = (";" << value)
          display_option << new_value
        end
      end
    end
    display_option
  end
  
  def display?(option)
    return false if display_options.nil?
    options = display_options.split(";")
    return true if options.include?(option)
    return false
  end
  
  
end
