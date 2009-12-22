class Ad < ActiveRecord::Base
  
  STATUS = {"Inactive" => false, "Active" => true}
  
  named_scope :active, :conditions => ["status = ?", true]
  
  has_one :ad_image
  has_one :ad_location
  
  validates_presence_of :ad_name, :ad_type
  validates_uniqueness_of :ad_name
  
  
  ##### Methods ######
  

  
end
