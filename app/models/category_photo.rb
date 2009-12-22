class CategoryPhoto < ActiveRecord::Base
  belongs_to :category
  
  has_attachment :content_type => :image,
                  :storage => :file_system,
                  :processor => 'Rmagick',
                  :resize_to => '800x600>',
                  :thumbnails => { :thumb => '100x100>' },
                  :size => 1..2.megabytes
                  
  validates_as_attachment
    
end
