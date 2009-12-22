class CouponsController < ApplicationController
  
  skip_before_filter :login_required#, :except => [:coupon_list]
  before_filter :dealer_login_required, :except => [:coupon_list]
  before_filter :login_to_view_coupons
  
  def index
    if params[:dealer_id]
      @dealer = current_user.dealer
      redirect_to :back rescue redirect_to root_path and return unless @dealer
      @coupons = Coupon.active_and_inactive.find(:all, :conditions => ["attachable_type = ? and attachable_id = ?", 'Dealer', @dealer.id])
    end
  end
  
  def new
    @coupon = Coupon.new
  end
  
  def create
    @dealer = current_user.dealer
    @coupon = Coupon.new(params[:coupon])
    if @coupon.save
      @dealer.coupons << @coupon
      @dealer.save
      flash[:notice] = t(:new_coupon_created)
      redirect_to coupons_path(:dealer_id => current_user.dealer.id)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @coupon = Coupon.find_by_id(params[:id])
    redirect_to coupons_path(:dealer_id => current_user.dealer.id) unless @coupon
  end
  
  def update
    @coupon = Coupon.find_by_id(params[:id])
    if @coupon.update_attributes(params[:coupon])
      flash[:notice] = t(:coupon_updated_successfully)
      redirect_to coupons_path(:dealer_id => current_user.dealer.id)
    else
      render :action => 'edit'
    end
  end
  
  def coupon_list
    flash[:notice] = nil
    @coupon = Coupon.find_by_id(params[:coupon_id])
    unless @coupon
      flash[:notice] = t(:invalid_coupon_selected)
      redirect_to :back rescue redirect_to root_path
    end
    if @coupon.attachable_type == 'Dealer'
      @dealer = Dealer.find_by_id(@coupon.attachable_id)
    elsif @coupon.attachable_type == 'Listing'
      @listing = Listing.find_by_id(@coupon.attachable_id)
    end
  end
  
  
  
  private ######
  
  def login_to_view_coupons
    flash[:notice] = "Only registered Carmandi users can get other coupons. Sign-up to view all coupons.<br />Log-in if you have an account on Carmandi.ca"
    login_required
  end
  
  
end
