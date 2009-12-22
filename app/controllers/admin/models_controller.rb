class Admin::ModelsController < ApplicationController
  
  skip_before_filter :login_required
  before_filter :models_permission

  layout 'admin'
  
  active_scaffold :vehicle_model do |config|
    config.label = "Models and their make"
    config.columns = [:name, :vehicle_make_id, :category_id]
    config.list.columns = [:name, :vehicle_make, :category]
    config.list.sorting = [{:name => 'ASC'}]
  end
  
  private
  
  def models_permission
    permission_required('vehicle_model')
  end
  
end
