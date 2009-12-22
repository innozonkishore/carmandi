class Admin::TypesController < ApplicationController
  
  skip_before_filter :login_required
  before_filter :type_permission

  layout 'admin'
  
#  active_scaffold :vehicle_type do |config|
#    config.label = "Existing Vehicle Types"
#    config.columns = [:name]
#    config.list.columns = [:name]
#    config.list.sorting = [{:name => 'ASC'}]
#  end
  
  
  private
  
  def type_permission
    permission_required('vehicle_type')
  end
  
end
