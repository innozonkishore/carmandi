class Admin::AdsController < ApplicationController
  
  skip_before_filter :login_required
  before_filter :manage_ad_permission
  
  layout 'admin'
  
  def index
    @ads = Ad.active.find(:all)
  end
  
  def new
    @ad = Ad.new
  end
  
  def create
    @ad = Ad.new(params[:ad])
    if @ad.save
      if params[:photo]
        @ad.ad_image = AdImage.new(:uploaded_data => params[:photo])
      end
      flash[:notice] = t(:new_ad_created)
      redirect_to admin_ads_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @ad = Ad.find_by_id(params[:id])
    unless @ad
      flash[:notice] = t(:Ad_not_found)
      redirect_to admin_ads_path
    end
  end
  
  def update
    @ad = Ad.find_by_id(params[:id])
    if @ad.update_attributes(params[:ad])
      if @ad.ad_image && params[:photo]
        @ad.ad_image.destroy
        @ad.ad_image = AdImage.new(:uploaded_data => params[:photo])
      elsif params[:photo]
        @ad.ad_image = AdImage.new(:uploaded_data => params[:photo])
      end
      flash[:notice] = t(:Ad_updated_successfully)
      redirect_to admin_ads_path
    else
      render :action => 'edit'
    end
  end
  
  def show
    @ad = Ad.active.find_by_id(params[:id])
    unless @ad
      flash[:notice] = t(:Ad_not_found)
      redirect_to admin_ads_path
    end
  end
  
  def view_ad_location
    @ad_locations = AdLocation.find(:all)
  end
  
  def specify_location
    
  end
  
  def save_ad_location
    @ad = Ad.active.find_by_id(params[:ad_id])
    location = params[:location]
    webpage = params[:webpage]
    final_location = location + "_" + webpage
    @ad_location = AdLocation.find_by_name(final_location)
    # @ad_location = AdLocation.find_by_id(params[:ad_location_id])
    if @ad_location
      if @ad_location.update_attribute(:ad_id, @ad.id)
        flash[:notice] = t(:Ad_location_saved)
        redirect_to admin_ads_path
      else
        flash[:notice] = t(:Some_error_occured_in_ad_location)
        redirect_to admin_ads_path
      end
    else
      flash[:notice] = t(:ad_location_not_exist_for_page)
      redirect_to admin_ads_path
    end
  end
  
  
  private
  
  def manage_ad_permission
    permission_required('manage_ad')
  end
  
end
