require 'xmlsimple'
require 'enumerator'

class VehiclesController < ApplicationController
  include ActionView::Helpers::FormOptionsHelper
  
  skip_before_filter :login_required, :only => [:show, :show_by_dealer, :used_car, :clearance_center, :select_category, :select_price, :search_result, :car_detail, :sell_your_car, :start_ad, :detail_info, :update_models]
  before_filter :save_location, :only => [:used_car]
  
  def index
  end
  
  def new
    @vehicle = Vehicle.new
    @max_upload_size = VEHICLE_PHOTOS_SIZE_LIMIT
    @max_images = VEHICLE_PHOTOS_LIMIT - @vehicle.vehicle_photos.size
    
    user = User.find_by_id(params[:user_id]) || current_user
    dealer_id = user.dealer.id
    all_vehicles = Vehicle.active.find(:all, :conditions => ["dealer_id = ?", dealer_id])
    if all_vehicles.empty?
      limit = 0
    else
      limit = all_vehicles.length
    end
    dealer = Dealer.find_by_id(dealer_id)
    if dealer.upload_limit <= limit
      flash[:notice] = t(:upload_limit_exceeded)
      redirect_to root_path and return
    end
    # @dealer_id = dealer_id
    @vehicle.dealer_id = dealer_id
    @vehicle_photo = VehiclePhoto.new
  end
  
  def create
    @vehicle = Vehicle.new(params[:vehicle])
    @max_upload_size = VEHICLE_PHOTOS_SIZE_LIMIT
    @max_images = VEHICLE_PHOTOS_LIMIT - @vehicle.vehicle_photos.size
    @vehicle.prepare_optional_features(params[:of])
    @vehicle.prepare_other_features(params[:other_feat], params[:other_feat_value], params[:other_feat_with_value])
    
    if @vehicle.create_by_admin(params[:vehicle_photos])
      @vehicle.update_attribute(:standard_features, session[:standard_features])
      session[:standard_features] = nil
      
      @vehicle.update_attribute(:vin_data, session[:vin_xml])
      session[:vin_xml] = nil     
      flash[:notice] = t(:vehicle_uploaded)
      redirect_to root_path
    else
      @data = XmlSimple.xml_in(session[:vin_xml])
      render :action => 'new'
    end
  end
  
  def edit
    @vehicle = Vehicle.find_by_id(params[:id])
    @data = XmlSimple.xml_in(@vehicle.vin_data)
  end
  
  def update
    @vehicle = Vehicle.find_by_id(params[:id])
    if @vehicle.update_vehicle(params[:vehicle], params[:vehicle_photos])
      @vehicle.save_optional_features(params[:of])
      @vehicle.save_other_features(params[:other_feat], params[:other_feat_value], params[:other_feat_with_value])
      flash[:notice] = t(:vehicle_updated)
      redirect_to admin_vehicles_path and return if current_user.is_admin? || current_user.is_representative?
      redirect_to uploaded_vehicles_users_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy_photo
    vehicle_photo = VehiclePhoto.find_by_id(params[:id])
    vehicle_photo.destroy
  end
  
  def used_car
    session[:clearance_center] = nil
    @vehicle_make = VehicleMake.find(:all, :order => "name ASC")
    @used_car = true
  end
  
  def clearance_center
    @clearance_center = true
    session[:clearance_center] = true
    @vehicle_make = VehicleMake.find(:all, :order => "name ASC")
  end
  
  def select_category
    @used_car = true
    @clearance_center = true
    redirect_to used_car_vehicles_path and return if request.get?
    if params[:zipcode].blank?
      flash[:notice] = t(:enter_zipcode)
      redirect_to used_car_vehicles_path and return
    end
    session[:zipcode] = params[:zipcode]
    loc = Geokit::Geocoders::MultiGeocoder.geocode(session[:zipcode])
    if !loc.success
      flash[:notice] = t(:zipcode_not_decoded)
      redirect_to used_car_vehicles_path and return
    end
    session[:lat] = loc.lat
    session[:lng] = loc.lng
    session[:vehicle_makes] = params[:vehicle_makes] || VehicleMake.find(:all).collect{|m| m.id}
    @category = Category.find(:all)
  end
  
  def select_price
    @used_car = true
    @clearance_center = true
    redirect_to used_car_vehicles_path and return if request.get?
    session[:search_category] = params[:categories] || Category.find_by_name('General').id
    session[:min_price] = session[:max_price] = nil
  end
  
  def search_result
    @used_car = true
    @clearance_center = true
    # redirect_to used_car_vehicles_path and return if request.get?
    if request.get? && (session[:vehicle_makes] == nil || session[:lat] == nil || session[:lng] == nil)
      redirect_to used_car_vehicles_path and return
    end
    @loc = Geokit::Geocoders::MultiGeocoder.geocode(session[:zipcode])
    
    if session[:min_price] == nil
      session[:min_price] = params[:min_price]
      session[:min_price] = '0' if session[:min_price] == ''
    end
    if session[:max_price] == nil
      session[:max_price] = params[:max_price]
    end
    minimum = session[:min_price]
    maximum = session[:max_price]
    make = session[:vehicle_makes].join(",")
    category = session[:search_category].join(",") rescue Category.find(:all).collect{|c| c.id}.join(",")
    if session[:clearance_center] == true
      if session[:max_price] == '' #params[:max_price] && params[:max_price] == ''
        @searched_vehicles = Vehicle.active.find(:all, :conditions => ["clearance_center = true and vehicle_make_id in (#{make}) and category_id in (#{category}) and price >= #{minimum}"], :origin => [session[:lat],session[:lng]], :order => 'distance').paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at ASC')
      elsif session[:max_price].to_i == 0
        @searched_vehicles = Vehicle.active.find(:all, :conditions => ["clearance_center = true and vehicle_make_id in (#{make}) and category_id in (#{category})"], :origin => [session[:lat],session[:lng]], :order => 'distance').paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at ASC')
      else
        @searched_vehicles = Vehicle.active.find(:all, :conditions => ["clearance_center = true and vehicle_make_id in (#{make}) and category_id in (#{category}) and price between #{minimum} and #{maximum}"], :origin => [session[:lat],session[:lng]], :order => 'distance').paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at ASC')
      end
    else
      if session[:max_price] == ''
        @searched_vehicles = Vehicle.active.find(:all, :conditions => ["vehicle_make_id in (#{make}) and category_id in (#{category}) and price >= #{minimum}"], :origin => [session[:lat],session[:lng]], :order => 'distance').paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at ASC')
      elsif session[:max_price].to_i == 0
        @searched_vehicles = Vehicle.active.find(:all, :conditions => ["vehicle_make_id in (#{make}) and category_id in (#{category})"], :origin => [session[:lat],session[:lng]], :order => 'distance').paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at ASC')
      else
        @searched_vehicles = Vehicle.active.find(:all, :conditions => ["vehicle_make_id in (#{make}) and category_id in (#{category}) and price between #{minimum} and #{maximum}"], :origin => [session[:lat],session[:lng]], :order => 'distance').paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at ASC')
        # @searched_vehicles = Vehicle.find_by_sql("SELECT * from vehicles WHERE vehicle_make_id in (#{make}) AND category_id in (#{category}) AND price between #{minimum} and #{maximum}")
      end
    end
    # session[:vehicle_makes] = session[:search_category] = nil
  end
  
  def show
    @main_ads = true
    @vehicle = Vehicle.find_by_id(params[:id])
    redirect_to root_path and return unless @vehicle
    if current_user && params[:save] == 'true'
      SavedVehicle.save_vehicle_history(current_user.id, @vehicle.id)
      flash[:notice] = t(:search_history_saved)
    end
    @standard_features = @vehicle.standard_features.split(';')
    op_feat = @vehicle.optional_features
    if op_feat
      @optional_features = op_feat.split(';')
    else
      @optional_features = nil
    end
    other_features = @vehicle.other_features
    if other_features
      @other_features = other_features.split(';')
    else
      @other_features = nil
    end
    @loc = Geokit::Geocoders::MultiGeocoder.geocode(session[:zipcode])
    data = @vehicle.vin_data
    @data = XmlSimple.xml_in(data)
  end
  
  def show_by_dealer
    @dealer = Dealer.find_by_id(params[:id])
    redirect_to root_path and return unless @dealer
    @loc = Geokit::Geocoders::MultiGeocoder.geocode(session[:zipcode])
    @searched_vehicles = Vehicle.active.find(:all, :conditions => ["dealer_id = ?", @dealer.id], :origin => [session[:lat],session[:lng]], :order => 'distance').paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at ASC')
  end
  
  def save_history
    @vehicle = Vehicle.find_by_id(params[:id])
    SavedVehicle.save_vehicle_history(current_user.id, @vehicle.id)
    flash[:notice] = t(:search_history_saved)
    redirect_to vehicle_path(@vehicle)
  end


  def update_models
    @vehicle_make = VehicleMake.find(params[:vehicle_id])
    render :text => options_for_select(@vehicle_make.vehicle_models.collect{|m| [ m.name, m.id ]})
  end
  
  def save_location
    if logged_in?
      loc = Geokit::Geocoders::MultiGeocoder.geocode(current_user.zipcode)
      if !loc.success
        flash[:notice] = t(:zipcode_not_decoded)
        redirect_to root_path and return
      end
      session[:zipcode] = current_user.zipcode
      session[:lat] = loc.lat
      session[:lng] = loc.lng
    end
  end
  
end
