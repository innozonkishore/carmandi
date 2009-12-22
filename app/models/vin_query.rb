class VinQuery < ActiveRecord::Base
  
  validates_presence_of :vin, :vin_data
  validates_uniqueness_of :vin
  
end
