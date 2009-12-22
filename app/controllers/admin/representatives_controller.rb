class Admin::RepresentativesController < ApplicationController
  
  layout 'admin'
  
  skip_before_filter :login_required, :except => [:home]
  before_filter :admin_login_required, :except => [:home]
  
  def index
    @representatives = User.representatives.find(:all)
    # render :action => 'index', :layout => 'admin'
  end
  
  def new
    @user = User.new
    @permission = Permission.new
  end
  
  def create
    @user = User.new(params[:user])
    @permission = @user.build_permission(params[:permission])
    if @user.save
      flash[:notice] = t(:new_representative_created)
      redirect_to admin_representatives_path
    else
      render :action => 'new'
    end
  end
  
  def home
  end
  
  def edit
    @user = User.find_by_id(params[:id])
    @permission = @user.permission
    unless @user
      redirect_to home_path and return
    end
  end
  
  def update
    @user = User.find_by_id(params[:id])
    @permission = @user.permission
    if @user.update_attributes(params[:user]) && @permission.update_attributes(params[:permission])
      flash[:notice] = t(:representative_updated)
      redirect_to admin_representatives_path
    else
      render :action => 'edit'
    end
  end
  
  def show
    @representative = User.representatives.find_by_id(params[:id])
    redirect_to root_path and return unless @representative
  end
  
  
end
