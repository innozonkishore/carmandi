class Admin::CouponsController < ApplicationController
  
  layout 'admin'
  
  
  def index
    @coupons = Coupon.active_and_inactive.find(:all, :conditions => ["attachable_type = 'Dealer' or attachable_type = 'Listing'"])
  end
  
  def new
    @coupon = Coupon.new
    if params[:dealer_id]
      @new = true
      @dealer = Dealer.find_by_id(params[:dealer_id])
      unless @dealer
        @new = false
      end
    elsif params[:listing_id]
      @new = true
      @listing = Listing.find_by_id(params[:listing_id])
      unless @listing
        @new = false
      end
    else
      @new = false
    end
  end
  
  def create
    if params[:image] && params[:dealer]
      @dealer = Dealer.find_by_id(params[:dealer])
      @dealer.coupons << Coupon.new(:uploaded_data => params[:image], :name => params[:coupon_name])
      @dealer.save
    elsif params[:image] && params[:listing]
      @listing = Listing.find_by_id(params[:listing])
      @listing.coupons << Coupon.new(:uploaded_data => params[:image], :name => params[:coupon_name])
      @listing.save
    else
      flash[:notice] = "Invalid entry. Please try again."
      redirect_to new_admin_coupon_path and return
    end
    flash[:notice] = t(:new_coupon_created)
    redirect_to admin_coupons_path
  end
  
  def edit
    @coupon = Coupon.find_by_id(params[:id])
    redirect_to admin_coupons_path and return unless @coupon
  end
  
  def update
    @coupon = Coupon.find_by_id(params[:id])
    if @coupon.update_attributes(params[:coupon])
      flash[:notice] = t(:coupon_updated_successfully)
      redirect_to admin_coupons_path
    else
      render :action => 'edit'
    end
  end
  
  def show
    @coupon = Coupon.find_by_id(params[:id])
    redirect_to admin_coupons_path and return unless @coupon
  end
  
  def show_by_dealer
    if params[:dealer_id]
      @dealer = Dealer.find_by_id(params[:dealer_id])
      unless @dealer
        flash[:notice] = "Please select a valid dealer"
        redirect_to admin_coupons_path and return
      end
      @coupons = @dealer.coupons
    else
      @dealer = nil
      # render :template => 'show_by_dealer' and return
    end
  end
  
  def show_for_listing
    if params[:listing_id]
      @listing = Listing.find_by_id(params[:listing_id])
      unless @listing
        flash[:notice] = "Please select a valid listing"
        redirect_to admin_coupons_path and return
      end
      @coupons = @listing.coupons
    else
      @listing = nil
    end
  end
  
  
  
end
