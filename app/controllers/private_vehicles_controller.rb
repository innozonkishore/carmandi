require 'xmlsimple'

class PrivateVehiclesController < ApplicationController
  include ActionView::Helpers::FormOptionsHelper
  
  skip_before_filter :login_required, :only => [:sell_your_car, :start_ad, :detail_info, :upload_photo, :review_ad, :post_ad, :post_ad_thankyou, :search, :listing, :show, :update_models]
  before_filter :private_seller_login_required, :only => [:edit, :update, :show_current_user_vehicle, :edit_photo, :update_photo]
  
  def sell_your_car
    @sell_your_car = true
    session[:vehicle] = nil
    session[:plan] = nil
    session[:unsupported_vehicle_id] = nil
  end
  
  def start_ad
    @sell_your_car = true
    redirect_to sell_your_car_path and return unless params[:plan] || session[:plan]
    if params[:plan]
      session[:plan] = params[:plan]
      @vehicle = UnsupportedVehicle.new
    else
      @vehicle = session[:vehicle]
    end
  end
  
  def detail_info
    @sell_your_car = true
    redirect_to sell_your_car_path and return if request.get?
    if params[:vehicle] && session[:vehicle] == nil
      @vehicle = UnsupportedVehicle.new(params[:vehicle])
      session[:vehicle] = @vehicle
    elsif params[:vehicle] && session[:vehicle]
      session[:vehicle][:model_year] = params[:vehicle][:model_year]
      session[:vehicle][:vehicle_make_id] = params[:vehicle][:vehicle_make_id]
      session[:vehicle][:model] = params[:vehicle][:vehicle_model]
      session[:vehicle][:trim] = params[:vehicle][:trim]
      session[:vehicle][:drive] = params[:vehicle][:drive]
      session[:vehicle][:category_id] = params[:vehicle][:category_id]
      session[:vehicle][:zipcode] = params[:vehicle][:zipcode]
      session[:vehicle][:vin] = params[:vehicle][:vin]
      @vehicle = session[:vehicle]
    else
      @vehicle = session[:vehicle]
    end
  end
  
  def upload_photo
    @sell_your_car = true
    redirect_to sell_your_car_path and return if request.get?
    if params[:vehicle] && session[:vehicle][:mileage] == nil
      @vehicle = UnsupportedVehicle.new(params[:vehicle])
      @vehicle.model_year = session[:vehicle][:model_year]
      @vehicle.vehicle_make_id = session[:vehicle][:vehicle_make_id]
      @vehicle.model = session[:vehicle][:model]
      @vehicle.trim = session[:vehicle][:trim]
      @vehicle.drive = session[:vehicle][:drive]
      @vehicle.category_id = session[:vehicle][:category_id]
      @vehicle.zipcode = session[:vehicle][:zipcode]
      @vehicle.vin = session[:vehicle][:vin]
      session[:vehicle][:options] = save_options(params[:options])
      @vehicle.options = session[:vehicle][:options]
      session[:vehicle] = @vehicle
    else
      session[:vehicle][:options] = save_options(params[:options])
      @vehicle = session[:vehicle]
    end
  end
  
  def review_ad
    @sell_your_car = true
    # redirect_to sell_your_car_path and return if request.get?
    @unsupported_vehicle = session[:vehicle]
    if @unsupported_vehicle.save!
      session[:unsupported_vehicle_id] = @unsupported_vehicle.id
      params[:photos].each do |photo|
        @unsupported_vehicle.photos << Photo.new(:uploaded_data => photo)
      end if params[:photos] && params[:photos].join != ""
      if session[:plan] && session[:plan] == 'basic'
        @unsupported_vehicle.delete_other_photos
      end
    else
      redirect_to sell_your_car_path and return
    end
  end
  
  def post_ad
    @sell_your_car = true
    redirect_to sell_your_car_path and return if request.get? and session[:unsupported_vehicle_id] == nil
    @payment_info = PaymentInfo.new
    if logged_in?
      @vehicle = session[:vehicle]
      @user = current_user
    else
      @vehicle = session[:vehicle]
      @user = User.new
    end
  end
  
  def post_ad_thankyou
    if session[:unsupported_vehicle_id] != nil
      if !logged_in? && params[:login_email] && params[:login_email] != ''
        # logout_keeping_session!
        user = User.authenticate(params[:login_email], params[:login_password])
        if user
          unless user.active
            flash[:notice] = t(:not_active)
            redirect_to root_path and return
          end
          self.current_user = user
          if session[:unsupported_vehicle_id] == nil || !current_user.is_private_seller?
            flash[:notice] = t(:unauthorize_to_upload)
            redirect_to root_path and return
          end
        else
          flash[:notice] = t(:wrong_password)
          redirect_to sell_your_car_post_ad_path and return
        end
      elsif !logged_in? && params[:new_user]
        # logout_keeping_session!
        @user = User.new(params[:user])
        @user.role_id = Role.private_seller_id
        success = @user && @user.save  #@user.save!
        if success && @user.errors.empty?
         self.current_user = @user # !! now logged in
         # redirect_to root_path and return
        else
         flash[:notice] = t(:fill_entries_correctly)
         redirect_to sell_your_car_post_ad_path and return
        end
      end
      if session[:plan] == 'vip'
        @payment_info = PaymentInfo.new(params[:payment_info])
        if @payment_info.save
          @payment_info.update_attribute(:user_id, current_user.id)
          uv = UnsupportedVehicle.find(session[:unsupported_vehicle_id])
          uv.update_attribute(:days, params[:payment_info][:price_option]) if uv
          save_private_vehicle
          @payment_info.update_attribute(:vehicle_id, session[:vehicle_id])
          session[:vehicle_id] = nil
          flash[:notice] = t(:vehicle_uploaded_success)
          redirect_to my_account_users_path and return
        else
          flash[:notice] = t(:fill_payment_entries)
          redirect_to sell_your_car_post_ad_path and return
        end
      else
        save_private_vehicle
        session[:vehicle_id] = nil
        flash[:notice] = t(:vehicle_uploaded_success)
        redirect_to my_account_users_path and return
      end
    else
      redirect_to root_path and return
    end
  end
  
  def search
    @private_sales = true
    session[:min_price] = session[:max_price] = nil
  end
  
  def listing
    @private_sales = true
    if params[:zipcode] == '' && session[:zipcode].blank?
      flash[:notice] = t(:provide_your_postal_code)
      redirect_to search_private_vehicles_path and return
    end
    session[:zipcode] = params[:zipcode] if params[:zipcode]
    @loc = Geokit::Geocoders::MultiGeocoder.geocode(session[:zipcode])
    if !@loc.success
      flash[:notice] = t(:provide_valid_postal_code)
      redirect_to search_private_vehicles_path and return
    end
    session[:lat] = @loc.lat
    session[:lng] = @loc.lng
    # if request.get? && !logged_in?
    #   redirect_to search_private_vehicles_path and return
    # end
    
    if session[:min_price] == nil
      session[:min_price] = params[:min_price]
      session[:min_price] = '0' if session[:min_price] == ''
    end
    if session[:max_price] == nil
      session[:max_price] = params[:max_price]
    end
    minimum = session[:min_price]
    maximum = session[:max_price]
    
    if session[:max_price] == ''
      @searched_vehicles = PrivateVehicle.active_min_price(minimum.to_i).paginate(:origin => [session[:lat],session[:lng]], :order => 'distance', :per_page => PER_PAGE, :page => params[:page])
    elsif session[:max_price].to_i == 0
      @searched_vehicles = PrivateVehicle.active.paginate(:origin => [session[:lat],session[:lng]], :order=>"distance", :per_page => PER_PAGE, :page => params[:page])
    else
      @searched_vehicles = PrivateVehicle.active_and_price_range(minimum.to_i, maximum.to_i).paginate(:conditions => ["price between #{minimum} and #{maximum}"], :origin => [session[:lat],session[:lng]], :order => 'distance', :per_page => PER_PAGE, :page => params[:page])
    end
  end
  
  def show
    @private_sales = true
    @vehicle = PrivateVehicle.find_by_id(params[:id])
    unless @vehicle
      flash[:notice] = t(:vehicle_does_not_exist)
      redirect_to root_path and return
    end
    unless @vehicle.options.nil?
      @options = @vehicle.options.split(';')
    end
  end
  
  def edit
    @vehicle = PrivateVehicle.find_by_id(params[:id])
    unless @vehicle
      flash[:notice] = t(:vehicle_does_not_exist)
      redirect_to root_path and return
    end
  end
  
  def update
    @vehicle = PrivateVehicle.find_by_id(params[:id])
    if @vehicle.update_attributes(params[:private_vehicle])
      @vehicle.update_attribute(:options, PrivateVehicle.save_options(params[:options]))
      flash[:notice] = t(:private_vehicle_updated)
      redirect_to manage_ads_user_path(current_user)
    else
      render :action => 'edit'
    end
  end
  
  def show_current_user_vehicle
    @vehicle = PrivateVehicle.find_by_id(params[:id])
    unless @vehicle
      flash[:notice] = t(:vehicle_does_not_exist)
      redirect_to root_path and return
    end
    unless @vehicle.options.nil?
      @options = @vehicle.options.split(';')
    end
  end
  
  def edit_photo
    @vehicle = PrivateVehicle.find_by_id(params[:id])
    unless @vehicle
      flash[:notice] = t(:vehicle_does_not_exist)
      redirect_to root_path and return
    end
    @photos = @vehicle.photos
  end
  
  def update_photo
    @vehicle = PrivateVehicle.find_by_id(params[:vehicle][:id])
    params[:photos].each do |photo|
      @vehicle.photos << Photo.new(:uploaded_data => photo)
    end if params[:photos] && params[:photos].join != ""
    if @vehicle.plan == 'basic'
      @vehicle.delete_other_photos
    end
    flash[:notice] = "Photo updated successfully"
    redirect_to manage_ads_user_path(current_user)
  end
  
  
  def update_models
    @vehicle_make = VehicleMake.find(params[:vehicle_id])
    render :text => options_for_select(@vehicle_make.vehicle_models.collect{|m| [ m.name, m.id ]})
  end
  
  def destroy
    @vehicle = PrivateVehicle.find_by_id(params[:id])
    @vehicle.destroy
    redirect_to manage_ads_user_path(current_user) and return
  end
  
  def save_history
    @vehicle = PrivateVehicle.find_by_id(params[:id])
    SavedVehicle.save_private_vehicle_history(current_user.id, @vehicle.id)
    flash[:notice] = t(:search_history_saved)
    redirect_to private_vehicle_path(@vehicle)
  end
  
  
  private
  
  def save_options(parameter)
    unless parameter.nil?
      options = ''
      parameter.each do |p|
        if options == ''
          options = p
        else
          options << ';'+p
        end
      end
      options
    end
  end

  
end