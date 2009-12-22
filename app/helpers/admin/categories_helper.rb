module Admin::CategoriesHelper
  
  def picture_form_column(record, input_name)
    file_field_tag   input_name
  end
  
  def picture_column(record)
    if record.category_photo
      image_tag record.category_photo.public_filename(:thumb) 
    else
      image_tag 'car_van.png'  
    end
  end  
end
