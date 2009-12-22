class Coupon < ActiveRecord::Base
  
  has_attachment :content_type => :image,
                 :storage => :file_system, 
                 :processor => "Rmagick",
                 :thumbnails => {:thumb => '130x100>', :large => '220x110>', :hover => '500x250>'},
                 :max_size => 2.megabytes,
                 :resize_to => '800x600>'
  
  validates_as_attachment
  
  # STATUS = {I18n.translate(:Active) => 'active', I18n.translate(:Inactive) => 'inactive', I18.translate(:Delete) => 'delete'}
  STATUS = {"Active" => 'active', "Inactive" => 'inactive', "Delete" => "delete"}
  
  named_scope :active_and_inactive, :conditions => ["status = ? or status = ?", 'active', 'inactive']
  
  belongs_to :attachable, :polymorphic => true
  
  # validates_presence_of :name
  
  
  #### Methods #####
  
  def after_update
    if self.primary_display == true
      if self.attachable_type == 'Dealer'
        dealer = Dealer.find_by_id(attachable_id)
        dealer.coupons.each {|c| c.update_attribute(:primary_display, false) unless c == self}
      elsif self.attachable_type == 'Listing'
        listing = Listing.find_by_id(attachable_id)
        listing.coupons.each {|c| c.update_attribute(:primary_display, false) unless c == self}
      end
    end
  end
  
end
