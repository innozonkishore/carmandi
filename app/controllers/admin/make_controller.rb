class Admin::MakeController < ApplicationController
  
  skip_before_filter :login_required
  before_filter :make_permission

  layout 'admin'
  
  active_scaffold :vehicle_make do |config|
    config.label = "Make"
    config.columns = [:name, :url]
    config.list.columns = [:name, :url]
    config.list.sorting = [{:name => 'ASC'}]
  end
  
  
  private
  
  def make_permission
    permission_required('vehicle_make')
  end
  
end
