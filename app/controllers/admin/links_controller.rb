class Admin::LinksController < ApplicationController
  
  skip_before_filter :login_required
  before_filter :link_permission, :only => [:new, :create, :edit, :update]
  before_filter :listing_permission, :only => [:listing_index, :add_listing, :new_listing, :create_listing, :edit_listing, :update_listing]

  layout 'admin', :except => [:show]
  
  def index
    @links = Link.active_and_inactive.find(:all, :order => 'position')
  end
  
  def new
    @link = Link.new
    @link.useful = true
  end
  
  def create
    @link = Link.new(params[:link])
    if @link.save
      FIVE_AD_LOCATIONS.each do |a|
         location = a + "_" + @link.name_english
         ad_location = AdLocation.new(:name => location)
         ad_location.save
      end
      flash[:notice] = I18n.translate(:new_link_created, :name => @link.name_english)
      redirect_to admin_links_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @link = Link.find_by_id(params[:id])
  end
  
  def update
    @link = Link.find_by_id(params[:id])
    old_name = @link.name_english
    if @link.update_attributes(params[:link])
      @link.modify_ad_location(old_name, @link.name_english) if old_name != @link.name_english
      flash[:notice] = t(:link_updtaed)
      redirect_to admin_links_path
    else
      render :action => 'edit'
    end
  end
  
  def show
    @show_link = true
    @link = Link.find_by_id(params[:id])
    unless @link
      flash[:notice] = t(:wrong_link_id)
      redirect_to root_path and return
    end
    @listings = Listing.active.find(:all, :conditions => ["link_id = ?", @link.id], :order => 'position')
    render :action => 'show', :layout => 'application'
  end
  
  def listing_index
    @listings = Listing.active_and_inactive.find(:all)
  end
  
  def add_listing
    @links = Link.active_and_inactive.find(:all, :order => 'position')
  end
  
  def new_listing
    @link = Link.find_by_id(params[:link_id])
    unless @link
      flash[:notice] = t(:wrong_link_id)
      redirect_to add_listing_admin_links_path and return
    end
    @listing = Listing.new
    @listing.link = @link
  end
  
  def create_listing
    @listing = Listing.new(params[:listing])
    if @listing.save
      if params[:photo]
        @listing.photo = Photo.new(:uploaded_data => params[:photo])
      end
      params[:coupons].each_with_index do |coupon, i|
        @listing.coupons << Coupon.new(:uploaded_data => coupon , :name => params[:coupon_names][i])
      end if params[:coupons] && params[:coupons].join != ""
      @listing.update_attribute(:display_options, @listing.save_display_options(params[:options]))
      flash[:notice] = t(:new_listing_created)
      redirect_to listing_index_admin_links_path
    else
      render :action => 'new_listing'
    end
  end
  
  def edit_listing
    @listing = Listing.find_by_id(params[:id])
  end
  
  def update_listing
    @listing = Listing.find_by_id(params[:id])
    if @listing.update_attributes(params[:listing])
      if params[:photo] && @listing.photo
        @listing.photo.update_attribute(:uploaded_data, params[:photo])
      elsif params[:photo]
        @listing.photo = Photo.new(:uploaded_data => params[:photo])
      end
      # params[:coupons].each_with_index do |coupon, i|
      #   @listing.coupons << Coupon.new(:uploaded_data => coupon , :name => params[:coupon_names][i])
      # end if params[:coupons] && params[:coupons].join != ""
      
      # if params[:coupon]# && params[:coupon_name]
      #   if coupon = @listing.coupon
      #     coupon.update_attributes(:uploaded_data => params[:coupon])
      #     coupon.update_attribute(:name, params[:coupon_name]) if !params[:coupon_name].blank?
      #   else
      #     @listing.coupon = Coupon.new(:uploaded_data => params[:coupon], :name => params[:coupon_name]) 
      #   end
      # end
      @listing.update_attribute(:display_options, @listing.save_display_options(params[:options]))
      flash[:notice] = t(:listing_updated)
      redirect_to listing_index_admin_links_path
    else
      render :action => 'edit_listing'
    end
  end
  
  
  private
  
  def link_permission
    permission_required('add_link')
  end
  
  def listing_permission
    permission_required('add_listing')
  end
  
end
