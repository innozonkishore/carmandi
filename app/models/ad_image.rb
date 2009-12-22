class AdImage < ActiveRecord::Base
  
  has_attachment :content_type => :image,
                 :storage => :file_system, 
                 # :processor => "Rmagick",
                 # :thumbnails => {:leftbar => '170x200>', :bottom => '311X80>', :center => '555X416>'},
                 :max_size => 2.megabytes
                 # :resize_to => '800x600>'
  
  validates_as_attachment
  
  belongs_to :ad
  
  
end
