# == Schema Information
# Schema version: 20090811110741
#
# Table name: vehicle_models
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  url             :string(255)
#  vehicle_make_id :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

class VehicleModel < ActiveRecord::Base
  
  belongs_to :vehicle_make
  belongs_to :category
  has_many :vehicles
  
  validates_presence_of :name
  validates_uniqueness_of :name, :unless => Proc.new {|n| n.name.blank?}
  
  
end
