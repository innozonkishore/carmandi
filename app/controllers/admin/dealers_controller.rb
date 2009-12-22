class Admin::DealersController < ApplicationController
  
  skip_before_filter :login_required
  before_filter :dealer_permission, :only => [:new, :create, :show, :search]
  before_filter :modify_dealer_permission, :only => [:edit, :update]
    
  layout 'admin'
  
  
  def index
    @dealers = Dealer.find(:all).paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at ASC')  #User.dealers.find(:all)
  end
  
  def new
    @user = User.new
    @dealer = Dealer.new
    @dealer.account_type = true
  end
  
  def create
    @user = User.new(params[:user])
    @user.zipcode = params[:dealer][:postal_code]
    @dealer = @user.build_dealer(params[:dealer])
    @dealer.dealer_logo = DealerLogo.new(:uploaded_data => params[:dealer_logo]) if params[:dealer_logo]
    @dealer.upload_limit = params[:upload_limit] unless params[:upload_limit].empty?
    if !params[:dealer_logo] && @user.save
      params[:coupons].each_with_index do |coupon, i|
        @dealer.coupons << Coupon.new(:uploaded_data => coupon , :name => params[:coupon_names][i])
      end if params[:coupons] && params[:coupons].join != ""
      flash[:notice] = t(:new_dealer_created)
      redirect_to admin_dealers_path
    elsif params[:dealer_logo] && @dealer.dealer_logo.valid? && @user.save
      params[:coupons].each_with_index do |coupon, i|
        @dealer.coupons << Coupon.new(:uploaded_data => coupon , :name => params[:coupon_names][i])
      end if params[:coupons] && params[:coupons].join != ""
      flash[:notice] = t(:new_dealer_created)
      redirect_to admin_dealers_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @dealer = Dealer.find_by_id(params[:id])
    unless @dealer
      redirect_to home_path and return
    end
    @user = @dealer.user
  end
  
  def update
    @dealer = Dealer.find_by_id(params[:id])
    @user = @dealer.user
    if @dealer.update_attributes(params[:dealer]) && @user.update_attributes(params[:user])# &&
      if params[:dealer_logo]
        if dealer_logo = @dealer.dealer_logo
          dealer_logo.update_attribute(:uploaded_data, params[:dealer_logo])
        else
          @dealer.dealer_logo = DealerLogo.new(:uploaded_data => params[:dealer_logo]) 
        end
      end
      # params[:coupons].each_with_index do |coupon, i|
      #   @dealer.coupons << Coupon.new(:uploaded_data => coupon , :name => params[:coupon_names][i])
      # end if params[:coupons] && params[:coupons].join != ""
      unless params[:upload_limit].empty?
        @dealer.update_attribute(:upload_limit, params[:upload_limit])
      end
      
      flash[:notice] = t(:dealer_updated)
      redirect_to admin_dealers_path
    else
      render :action => 'edit'
    end
  end
  
  def show
    @dealer = Dealer.find_by_id(params[:id])
    @user = @dealer.user
    redirect_to root_path and return unless @dealer
  end
  
  def search
    if params[:dealership_name]
      @dealer = Dealer.find(:first, :conditions => ["dealership_name = ?", params[:dealership_name]])
    end
  end
  
  
  private
  
  def dealer_permission
    permission_required('create_dealer')
  end
  
  def modify_dealer_permission
    permission_required('modify_dealer')
  end
  
  
end
