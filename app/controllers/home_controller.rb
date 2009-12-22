class HomeController < ApplicationController
  
  skip_before_filter :login_required
  
  def index
    @main_ads = true
  end
  
  def change_language
    redirect_to root_path and return unless params[:lang]
    session[:locale] = params[:lang]
    # redirect_to :back and return rescue redirect_to root_path and return
    redirect_to params[:current_url] and return rescue redirect_to root_path and return
  end
  
  
  
  
end
