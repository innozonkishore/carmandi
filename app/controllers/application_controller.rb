# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :representative_role_id, :permission_required

  include AuthenticatedSystem
  before_filter :set_locale
  before_filter :login_required
  before_filter :save_location

  # def access_denied
  #   alias new_session_path login_path
  #   super
  # end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:created_at, :updated_at]
    # config.theme = :blue
  end
  
  def set_locale                                            # update session if passed   
    session[:locale] = params[:locale] if params[:locale]   # set locale based on session or default   
    I18n.locale = session[:locale] || I18n.default_locale 
  end

  
  def representative_role_id
    return @representative_role_id if @representative_role_id
    @representative_role_id = Role.find_by_name("representative").id
  end

  def save_location
    unless session[:zipcode]
      session[:zipcode] = '94105'
      session[:lat] = '49.1572'
      session[:lng] = '-122.811'
    end
  end
  
  def permission_required(permission)
    u = User.find_by_id(session[:user_id])
    if u
      if u.is_admin? || (u.is_representative? && u.has_permission?(permission))
        return
      else
        flash[:notice] = t(:no_access)
        redirect_to root_path
      end
    else
      flash[:notice] = t(:no_access)
      redirect_to root_path
    end
  end
  
  def admin_login_required
    u = User.find_by_id(session[:user_id])
    if u
      if u.is_admin?
        return
      end
    else
      flash[:notice] = t(:please_login)
      redirect_to login_path and return
    end
    flash[:notice] = t(:no_access)
    redirect_to root_path
  end
  
  def private_seller_login_required
    u = User.find_by_id(session[:user_id])
    if u
      if u.is_private_seller?
        return
      end
    end
    flash[:notice] = t(:no_access)
    redirect_to :back rescue root_path
  end
  
  def buyer_login_required
    u = User.find_by_id(session[:user_id])
    if u
      if u.is_buyer?
        return
      end
    end
    flash[:notice] = t(:no_access)
    redirect_to :back rescue redirect_to root_path
  end
  
  def save_private_vehicle
    uv = UnsupportedVehicle.find(session[:unsupported_vehicle_id])
    if uv
      private_vehicle = PrivateVehicle.new(:vin=>uv.vin, :model_year=>uv.model_year, :doors=>uv.doors, :interior_color=>uv.interior_color, :exterior_color=>uv.exterior_color, :trim=>uv.trim, :engine_type=>uv.engine_type, :transmission=>uv.transmission, :zipcode=>uv.zipcode, :vin_data=>uv.vin_data, :detailed_info=>uv.detailed_info, :mileage=>uv.mileage, :asking_price=>uv.asking_price, :vehicle_make_id=>uv.vehicle_make_id, :model=>uv.model, :category_id=>uv.category_id, :days=>uv.days, :user_id=>current_user.id, :drive=>uv.drive, :options=>uv.options, :plan=>session[:plan])
      if private_vehicle.save!
        session[:vehicle_id] = private_vehicle.id
        uv.photos.each do |photo|
          photo.update_attributes(:attachable_type => "PrivateVehicle", :attachable_id => private_vehicle.id)
        end
        uv.destroy
      end
    end
  end
  
  def dealer_login_required
    u = User.find_by_id(session[:user_id])
    if u
      if u.is_dealer?
        return
      end
    end
    flash[:notice] = t(:no_access)
    redirect_to :back rescue redirect_to root_path
  end
  
  
  # def redirect_to_back
  #   redirect_to :back rescue root_path
  # end

end
