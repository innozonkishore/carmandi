class Admin::CategoriesController < ApplicationController
  
  skip_before_filter :login_required
  before_filter :category_permission
  
  layout 'admin'
  
  active_scaffold :category do |config|
    config.label = "Existing Categories"
    config.columns = [:name]
    config.list.columns = [:name, :picture]
    config.create.columns = [:name, :picture]
    config.update.columns = [:name, :picture]
    config.show.columns = [:name, :picture]
    
    
    config.create.multipart = true
    config.update.multipart = true
    
  end
  
  def category_permission
    permission_required('category')
  end
end
