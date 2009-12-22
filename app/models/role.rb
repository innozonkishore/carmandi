# == Schema Information
# Schema version: 20090811110741
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
 
#### Associations #### 
  has_many :users
  
#### Validations ####
  validates_presence_of :name
  validates_uniqueness_of :name,  :unless => Proc.new{|a| a.name.blank?}
  
  
  def self.admin_id
    find_by_name("SWA").id rescue nil
  end
  
  def self.representative_id
    find_by_name("representative").id rescue nil
  end
  
  def self.dealer_id
    find_by_name("Dealer").id rescue nil
  end
  
  def self.private_seller_id
    find_by_name("Private seller").id rescue nil
  end
  
  def self.buyer_id
    find_by_name("Buyer").id rescue nil
  end
  
end
