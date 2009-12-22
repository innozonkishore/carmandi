class Dealer < ActiveRecord::Base
  
  
  TYPE = { "self-served" => 0, "full-served" => 1}
  UPLOAD_LIMIT = [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100]
    
  belongs_to :user
  
  has_one :dealer_logo, :as => :attachable, :dependent => :destroy
  has_many :coupons, :as => :attachable, :dependent => :destroy
  has_many :vehicles, :dependent => :destroy
  
  validates_presence_of :dealership_name, :city, :province, :phone_number, :address, :postal_code, :upload_limit
  validates_associated :dealer_logo
  validates_associated :coupons
  validates_numericality_of :upload_limit

  #### Methods ####
  
  def self.active
    dealer = []
    Dealer.find(:all).each do |d|
      dealer << d if d.user.active
    end
    dealer
  end
  
  def primary_coupon
    coupon = Coupon.find(:first, :conditions => ["attachable_type = ? and attachable_id = ? and status = ? and primary_display = ?", 'Dealer', self.id, 'active', true])
    return coupon if coupon
    coupons.first
  end
  


end
