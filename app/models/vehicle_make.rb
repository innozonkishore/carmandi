# == Schema Information
# Schema version: 20090811110741
#
# Table name: vehicle_makes
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class VehicleMake < ActiveRecord::Base
  
  has_many :vehicle_models, :dependent => :destroy
  has_many :vehicles
  
  validates_presence_of :name
  validates_uniqueness_of :name, :unless => Proc.new {|n| n.name.blank?}
  
end
