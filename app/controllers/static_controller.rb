class StaticController < ApplicationController
  
  skip_before_filter :login_required
  
  def new_cars
    @vehicle_makes = VehicleMake.find(:all, :order => "name ASC")
    @new_car = true
  end
  
  def about_us
    @main_ads = true
  end
  
  def privacy_policy
    @main_ads = true
  end
  
  def contact_us
    @main_ads = true
  end
  
  def calculator
    @calculator = true
    render :layout => 'calculator'
  end
  
  # def carproof_history_report
  #   @carproof_history = true
  # end
  
end
