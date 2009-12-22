class DealerLogo < ActiveRecord::Base
  
  has_attachment :content_type => :image,
                 :storage => :file_system, 
                 :thumbnails => {:thumb => '120x100'},
                 :max_size => 2.megabytes,
                 :resize_to => '800x600>'
  
  validates_as_attachment
  
  belongs_to :attachable, :polymorphic => true
  
end
