class AdLocation < ActiveRecord::Base
  
  LOCATION = ["leftbar", "rightbar", "bottom_row_left", "bottom_row_middle", "bottom_row_right", "center"]
  
  belongs_to :ad
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  ##### Methods ######
  
  def self.leftbar_ad(location)
    ad_location = AdLocation.find_by_name(location)
    if ad_location and ad_location.ad
      advertisement = ad_location.ad
      if advertisement.ad_type == 'Code'
        ["0", advertisement.code]
      else
        if advertisement.url != ''
          # ["1", advertisement.ad_image.public_filename(:leftbar), advertisement.url]
          ["1", advertisement.ad_image.public_filename, advertisement.url]
        else
          # ["1", advertisement.ad_image.public_filename(:leftbar)]
          ["1", advertisement.ad_image.public_filename]
        end
      end
    else
      ["1", "/images/ads/8.png"]
    end
  end
  
  def self.rightbar_ad(location)
    ad_location = AdLocation.find_by_name(location)
    if ad_location and ad_location.ad
      advertisement = ad_location.ad
      if advertisement.ad_type == 'Code'
        ["0", advertisement.code]
      else
        if advertisement.url != ''
          ["1", advertisement.ad_image.public_filename, advertisement.url]
        else
          ["1", advertisement.ad_image.public_filename]
        end
      end
    else
      ["1", "/images/ads/8.png"]
    end
  end
  
  def self.bottom_row_left_ad(location)
    ad_location = AdLocation.find_by_name(location)
    if ad_location and ad_location.ad
      advertisement = ad_location.ad
      if advertisement.ad_type == 'Code'
        ["0", advertisement.code]
      else
        if advertisement.url != ''
          ["1", advertisement.ad_image.public_filename, advertisement.url]
        else
          ["1", advertisement.ad_image.public_filename]
        end
      end
    else
      ["1", "/images/ads/1.gif"]
    end
  end
  
  def self.bottom_row_middle_ad(location)
    ad_location = AdLocation.find_by_name(location)
    if ad_location and ad_location.ad
      advertisement = ad_location.ad
      if advertisement.ad_type == 'Code'
        ["0", advertisement.code]
      else
        if advertisement.url != ''
          ["1", advertisement.ad_image.public_filename, advertisement.url]
        else
          ["1", advertisement.ad_image.public_filename]
        end
      end
    else
      ["1", "/images/ads/2.jpg"]
    end
  end
  
  def self.bottom_row_right_ad(location)
    ad_location = AdLocation.find_by_name(location)
    if ad_location and ad_location.ad
      advertisement = ad_location.ad
      if advertisement.ad_type == 'Code'
        ["0", advertisement.code]
      else
        if advertisement.url != ''
          ["1", advertisement.ad_image.public_filename, advertisement.url]
        else
          ["1", advertisement.ad_image.public_filename]
        end
      end
    else
      ["1", "/images/ads/3.gif"]
    end
  end
  
  def self.center_ad
    ad_location = AdLocation.find_by_name("center_home")
    if ad_location.ad
      advertisement = ad_location.ad
      if advertisement.ad_type == 'Code'
        ["0", advertisement.code]
      else
        if advertisement.url != ''
          ["1", advertisement.ad_image.public_filename, advertisement.url]
        else
          ["1", advertisement.ad_image.public_filename]
        end
      end
    else
      false
    end
  end
  
  
  
end
