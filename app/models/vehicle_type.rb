# == Schema Information
# Schema version: 20090811110741
#
# Table name: vehicle_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class VehicleType < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name, :unless => Proc.new {|n| n.name.blank?}
  
end
