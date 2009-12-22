# == Schema Information
# Schema version: 20090811110741
#
# Table name: permissions
#
#  id            :integer(4)      not null, primary key
#  category      :boolean(1)
#  vehicle_make  :boolean(1)
#  vehicle_model :boolean(1)
#  vehicle_type  :boolean(1)
#  create_dealer :boolean(1)
#  modify_dealer :boolean(1)
#  user_id       :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class Permission < ActiveRecord::Base
  
  belongs_to :user
  
end
