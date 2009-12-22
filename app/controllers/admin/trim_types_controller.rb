class Admin::TrimTypesController < ApplicationController
  
  skip_before_filter :login_required
  before_filter :vehicle_trim_type_permission
  
  layout 'admin'
  
  active_scaffold :vehicle_trim_type do |config|
    config.label = "Vehicle Trim Types"
    config.columns = [:trim_type]
    config.list.columns = [:trim_type]
    config.list.sorting = [{:trim_type => 'ASC'}]
  end
  
  
  private
  
  def vehicle_trim_type_permission
    permission_required('vehicle_trim_types')
  end
  
end
