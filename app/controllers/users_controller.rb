class UsersController < ApplicationController
  
  skip_before_filter :login_required, :only => [:new, :create, :forgot, :reset, :buyer_signup]
  before_filter :private_seller_login_required, :only => [:manage_ads]
  before_filter :buyer_login_required, :only => [:vehicle_history]

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    if session[:unsupported_vehicle_id] != nil
      @user.role_id = Role.private_seller_id
    end
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      session[:buyer] = nil
      redirect_back_or_default('/')
      flash[:notice] = t(:thanks_for_signup)
    else
      if session[:buyer] = true
        # flash[:error]  = t(:no_account_created)
        render :action => 'buyer_signup' and return
      end
      flash[:error]  = t(:no_account_created)
      render :action => 'new'
    end
  end
  
  def my_account
    
  end
  
  def manage_ads
    @user = User.find_by_id(params[:id])
    unless @user
      flash[:notice] = t(:no_such_user)
      redirect_to :back rescue root_path and return
    end
    @vehicles = PrivateVehicle.paginate(:conditions => ["status = ? and user_id = ?", 'active', @user.id], :per_page => PER_PAGE, :page => params[:page], :order => 'created_at ASC')
  end
  
  def vehicle_history
    @saved_vehicles = SavedVehicle.find(:all, :conditions => ["user_id = ?", current_user.id])
  end
  
  def uploaded_vehicles
    @vehicles = Vehicle.active.find(:all, :conditions => ["dealer_id = ?", current_user.dealer.id])
  end
  
  def buyer_signup
    @user = User.new
    @user.role_id = Role.buyer_id
    session[:buyer] = true
  end
  
  def forgot
    if request.post?
      user = User.find_by_email(params[:user][:email])
      if user
        user.create_reset_code
        flash[:notice] = t(:reset_code_sent, :email => user.email)
      else
        flash[:notice] = t(:email_dont_exist, :email => params[:user][:email])
      end
      redirect_back_or_default('/')
    end
  end

  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    redirect_back_or_default('/') and return unless @user
    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        @user.delete_reset_code
        flash[:notice] = t(:password_reset_success, :email => @user.email)
        redirect_back_or_default('/')
      else
        render :action => :reset
      end
    end
  end
  
  
end
