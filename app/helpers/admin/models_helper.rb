module Admin::ModelsHelper
  
  def vehicle_make_id_form_column(record, input_name)
    select :record, :vehicle_make_id, VehicleMake.find(:all).collect{|p| [p.name, p.id]}
  end
  
  def vehicle_make_id_column(record)
    "#{record.vehicle_make.name}"
  end
  
  def category_id_form_column(record, input_name)
    select :record, :category_id, Category.find(:all).collect{|p| [p.name, p.id]}
  end
  
  def category_id_column(record)
    record.category.name
  end
  
end
