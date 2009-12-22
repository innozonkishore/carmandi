# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  skip_before_filter :login_required, :only => [:new, :create]

  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      unless user.active
        flash[:notice] = t(:not_active)
        redirect_to root_path and return
      end
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      # if session[:unsupported_vehicle_id] != nil && current_user.is_private_seller?
      #   save_private_vehicle
      #   flash[:notice] = "Your vehicle has been uploaded successfully"
      #   redirect_to root_path and return
      # end
      flash[:notice] = t(:logged_in_successfully)
      redirect_to(admin_home_path) and return if current_user.is_admin? || current_user.is_representative?
      redirect_back_or_default(root_path) and return
    else
      note_failed_signin
      flash[:notice] = t(:wrong_password)
      @login       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = t(:logout_successful)
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    # flash[:error] = t(:error_login, :email => params[:email])
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
