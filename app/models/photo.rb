class Photo < ActiveRecord::Base
  
  has_attachment :content_type => :image,
                 :storage => :file_system, 
                 :processor => "Rmagick",
                 :thumbnails => {:thumb => '80x60>', :large => '370x500>'},
                 :max_size => 2.megabytes,
                 :resize_to => '800x600>'
  
  validates_as_attachment
  
  belongs_to :attachable, :polymorphic => true
  
end
