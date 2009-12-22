class Link < ActiveRecord::Base
  
  STATUS = ["active", "inactive", "delete"]
  WEBPAGE = ["home", "new_car", "used_car", "clearance_center", "private_sales", "sell_your_car", "monthly_payment_calculator"]
  
  ##### Validations #####
  validates_presence_of :name_english, :name_hindi, :name_urdu, :name_punjabi
  validates_uniqueness_of :name_english, :name_hindi, :name_urdu, :name_punjabi

  
  ##### Associations ######
  has_many :listings, :dependent => :destroy
  
  named_scope :useful, :conditions => ["useful = ?", true], :order => 'position'
  named_scope :important, :conditions => ["useful = ?", false]
  named_scope :useful_active, :conditions => ["status = ? and useful = ?", 'active', true], :order => 'position'
  named_scope :important_active, :conditions => ["status = ? and useful = ?", 'active', false], :order => 'position'
  named_scope :active, :conditions => ["status = ?", 'active'], :order => 'position'
  named_scope :active_and_inactive, :conditions => ["status = ? or status = ?", 'active', 'inactive'], :order => 'position'
 
  
  ##### Methods ######
  
  def modify_ad_location(old_name, new_name)
    FIVE_AD_LOCATIONS.each do |a|
       location = a + "_" + old_name
       new_location = a + "_" + new_name
       if @adlocation = AdLocation.find_by_name(location)
         @adlocation.update_attribute(:name, new_location)
       else
         ad_location = AdLocation.new(:name => new_location)
         ad_location.save
       end
    end
  end
  
  def self.all_ad_webpages
    links = self.active.collect(&:name_english).join(',')
    link = links.split(",")
    return (WEBPAGE + link)
  end
  
  
end
