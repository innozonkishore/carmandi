require 'xmlsimple'

class Admin::VehiclesController < ApplicationController
#  skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => :swfupload
  
  include ActionView::Helpers::FormOptionsHelper
  
  skip_before_filter :login_required
  before_filter :type_permission, :only => [:index]
  before_filter :upload_permission, :except => [:index, :edit, :update, :vin_lookup, :swfupload]
  before_filter :modify_permission, :only => [:edit, :update]
  before_filter :listing_permission, :only => [:show, :search]
  
  layout 'admin'
  
  def index
    if params[:sort_by] == 'dealership'
      @vehicles = Vehicle.active_and_inactive.paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'dealer_id')
    elsif params[:sort_by] == 'status'
      @vehicles = Vehicle.active_and_inactive.paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'status ASC')
    else      
      @vehicles = Vehicle.active_and_inactive.paginate(:per_page => PER_PAGE, :page => params[:page], :order => 'created_at')
    end
  end
  
  def new
    @vehicle = Vehicle.new
    @max_upload_size = VEHICLE_PHOTOS_SIZE_LIMIT
    @max_images = VEHICLE_PHOTOS_LIMIT - @vehicle.vehicle_photos.size
    @all_dealers = Dealer.active
#    session[:dealer_id] = params[:dealer_id] if params[:dealer_id]
    if params[:dealer_id] 
      all_vehicles = Vehicle.find(:all, :conditions => ["dealer_id = ?", params[:dealer_id]])
      if all_vehicles.empty?
        limit = 0
      else
        limit = all_vehicles.length
      end
      dealer = Dealer.find_by_id(params[:dealer_id])
      if dealer.upload_limit <= limit
        flash[:notice] = t(:upload_limit_exceeded)
        redirect_to admin_vehicles_path and return
      end
#      @dealer_id = params[:dealer_id]
      @vehicle.dealer_id = params[:dealer_id]
      @vehicle_photo = VehiclePhoto.new
    end
  end
  
  def create
    @vehicle = Vehicle.new(params[:vehicle])
    @max_upload_size = VEHICLE_PHOTOS_SIZE_LIMIT
    @max_images = VEHICLE_PHOTOS_LIMIT - @vehicle.vehicle_photos.size
    @vehicle.prepare_optional_features(params[:of])
    @vehicle.prepare_other_features(params[:other_feat], params[:other_feat_value], params[:other_feat_with_value])
    
    if @vehicle.create_by_admin(params[:vehicle_photos])
      @vehicle.update_attribute(:standard_features, session[:standard_features])
      session[:standard_features] = nil
      
      @vehicle.update_attribute(:vin_data, session[:vin_xml])
      session[:vin_xml] = nil
      flash[:notice] = t(:vehicle_uploaded)
      redirect_to admin_vehicles_path
    else
      # flash[:notice] = t(:fill_correct_entries)
      @data = XmlSimple.xml_in(session[:vin_xml])
      render :action => 'new'
      # redirect_to new_admin_vehicle_path(:dealer_id => params[:vehicle][:dealer_id])
    end
  end
  
  def swfupload
    # swfupload action set in routes.rb
    @photo = VehiclePhoto.new :uploaded_data => params[:Filedata]
    @photo.save!
    
    # This returns the thumbnail url for handlers.js to use to display the thumbnail
    render :text => @photo.id
  rescue
    render :text => "Error"
  end  
  
  def edit
    @vehicle = Vehicle.find_by_id(params[:id])
    @data = XmlSimple.xml_in(@vehicle.vin_data)
  end
  
  def update
    @vehicle = Vehicle.find_by_id(params[:id])
    if @vehicle.update_vehicle(params[:vehicle], params[:vehicle_photos])
      @vehicle.save_optional_features(params[:of])
      @vehicle.save_other_features(params[:other_feat], params[:other_feat_value], params[:other_feat_with_value])
      flash[:notice] = t(:vehicle_updated)
      redirect_to admin_vehicles_path
    else
      render :action => 'edit'
    end
  end
  
  def show
    @vehicle = Vehicle.find_by_id(params[:id])
    unless @vehicle
      flash[:notice] = "No such vehicle exists"
      redirect_to :back || root_path and return
    end
  end
  
  def search
    if params[:search_vin]
      @vehicle = Vehicle.find(:first, :conditions => ["vin = ?", params[:search_vin]])
    end
  end
  
  
  def update_models
    @vehicle_make = VehicleMake.find(params[:vehicle_id])
    render :text => options_for_select(@vehicle_make.vehicle_models.collect{|m| [ m.name, m.id ]})
  end
  
  
  def vin_lookup
    if params[:vin].blank?
      render :update do |page|
        page.alert "VIN can't be blank"
      end
    else

      if RAILS_ENV == 'production'
        vin_query = VinQuery.find_by_vin(params[:vin])
        if vin_query
          xml = vin_query.vin_data
        else
          response = Net::HTTP.get_response('www.vinquery.com',"/ws_POQCXTYNO1D/xml_v100_QA7RTS8Y.aspx?accessCode=03e4cdba-312c-4c88-a838-148df444a29d&vin=#{params[:vin]}&reportType=2")
          xml = response.body
          new_vin_query = VinQuery.new(:vin => params[:vin], :vin_data => xml)
          new_vin_query.save
        end
      else
        xml = File.read('public/vinquery.xml')
      end 
     session[:vin_xml] = xml
     data = XmlSimple.xml_in(xml)
     @data = data

      if data["VIN"].first["Status"] != 'SUCCESS'
        render :update do |page|
          page.alert "Please enter a valid VIN"
        end
        return
      end
      
      render :update do |page|
        
        page<<"$('vehicle_model_year').value = '#{data["VIN"].first["Vehicle"].first['Model_Year']}' "
        page<<"$('vehicle_body_styles').value = '#{data["VIN"].first["Vehicle"].first['Item'].collect{|x| x['Value'] if x['Key'] == 'Body Style'}.compact.first}' "
        page<<"$('vehicle_trim').value = '#{data["VIN"].first["Vehicle"].first['Trim_Level']}' "        

        make = VehicleMake.find_by_name(data["VIN"].first["Vehicle"].first['Make'])
        unless make
          make = VehicleMake.create(:name => data["VIN"].first["Vehicle"].first['Make'] )          
          page<<"op = document.createElement('option'); op.text = '#{make.name}'; op.value = '#{make.id}';"
          page<< "$('vehicle_vehicle_make_id').options[$('vehicle_vehicle_make_id').options.length] = op"
        end
        page<<"$('vehicle_vehicle_make_id').value = '#{make.id}' "        

        
        model = VehicleModel.find_by_name(data["VIN"].first["Vehicle"].first['Model'])
        unless model
          model = VehicleModel.create(:name => data["VIN"].first["Vehicle"].first['Model'], :vehicle_make_id => make.id, :category_id => Category.general.id)
          page<<"op = document.createElement('option'); op.text = '#{model.name}'; op.value = '#{model.id}';"
          page<< "$('vehicle_vehicle_model_id').options[$('vehicle_vehicle_model_id').options.length] = op"
        end
        page<<"$('vehicle_category_id').value = '#{model.category.id}' " if model.category
        
        page<<"$('vehicle_vehicle_model_id').value = '#{model.id}' " 
        
        int_color = data["VIN"].first["Vehicle"].first['Item'].collect{|x| x['Value'] if x['Key'] == 'Interior Trim'}.compact.to_s.split(' | ')
        int_color.each do |i_c|
         page<<"op = document.createElement('option'); op.text = '#{i_c}'; op.value = '#{i_c}';"
         page<< "$('vehicle_interior_color').options[$('vehicle_interior_color').options.length] = op"
        end
        ext_color = data["VIN"].first["Vehicle"].first['Item'].collect{|x| x['Value'] if x['Key'] == 'Exterior Color'}.compact.to_s.split(' | ')
        ext_color.each do |e_c|
         page<<"op = document.createElement('option'); op.text = '#{e_c}'; op.value = '#{e_c}';"
         page<< "$('vehicle_exterior_color').options[$('vehicle_exterior_color').options.length] = op"
        end
        
        
        # constant_features = ["VINquery_Vehicle_ID", "Exterior Color", "Interior Trim", "Model Year", "Make", "Model", "Trim Level", "Body Style", "Engine Type", "Transmission-long"]
        page.replace_html 'specification', :partial => "specification", :locals => {:data => data}
        @standard_features = data["VIN"].first["Vehicle"].first['Item'].collect{|x| x['Key'] if x['Value'] == 'Std.'}.compact
        page.show 'specification'
        page.replace_html 'specification1', :partial => "standard_features", :locals => {:standard_features => @standard_features}
        session[:standard_features] = @standard_features.join(';')
        page.show 'specification1'
        @optional_features = data["VIN"].first["Vehicle"].first['Item'].collect{|x| x['Key'] if x['Value'] == 'Opt.'}.compact
        page.replace_html 'specification2', :partial => "optional_features", :locals => {:optional_features => @optional_features}
        page.show 'specification2'
        @other_features = data["VIN"].first["Vehicle"].first['Item'].collect{|x| x['Key'] if x['Value'] == 'No data'}.compact
        @other_features_with_value = data["VIN"].first["Vehicle"].first['Item'].collect{|x| x['Key'] if x['Value'] != 'No data' && x['Value'] != 'Opt.' && x['Value'] != 'Std.' && x['Value'] != 'N/A' && !(CONSTANT_FEATURES.include?(x['Key']))}.compact
        page.replace_html 'specification3', :partial => "other_features", :locals => {:other_features => @other_features, :other_features_with_value => @other_features_with_value, :data => data}
        page.show 'specification3'
        
      end
    end
    

  end
  
  
  private
  
  def type_permission
    permission_required('view_vehicle_list')
  end
  
  def upload_permission
    permission_required('upload_vehicle')
  end
  
  def modify_permission
    permission_required('modify_vehicle')
  end
  
  def listing_permission
    permission_required('view_vehicle_list')
  end
  
end
