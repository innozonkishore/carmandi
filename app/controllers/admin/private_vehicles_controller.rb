class Admin::PrivateVehiclesController < ApplicationController
  
  skip_before_filter :login_required
  before_filter :admin_login_required
  
  layout 'admin'
  
  def index
    @private_vehicles = PrivateVehicle.active_and_inactive.paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at')
  end
  
  def edit
    @vehicle = PrivateVehicle.find_by_id(params[:id])
  end
  
  def update
    @vehicle = PrivateVehicle.find_by_id(params[:id])
    if @vehicle.update_attributes(params[:private_vehicle])
      @vehicle.update_attribute(:options, PrivateVehicle.save_options(params[:options]))
      flash[:notice] = "Private Vehicle updated successfully"
      redirect_to admin_private_vehicles_path
    else
      flash[:notice] = "Some error occured while updating your vehicle. Please try again."
    end
  end
  
  
  
end
