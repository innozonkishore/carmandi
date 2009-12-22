require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module CategorySpecHelper
  def valid_category_attributes
    { :name => 'first category' }
  end
end

describe Category do
  include CategorySpecHelper
  fixtures :categories, :category_photos
  
  before do
    @category = categories(:luxury)
    @general_category = categories(:general)
    @general_photo = category_photos(:general_thumb_image)
  end

  it 'must invalidate without a name' do
    Category.should need(:name).using(valid_category_attributes)
  end
  
  it 'should have a unique name' do
    Category.should need(:name).to_be_unique.using(valid_category_attributes)
  end
  
  it "should have many vehicles" do
    Category.should have_many(:vehicles)
  end
  
  it "should have many vehicle models" do
    Category.should have_many(:vehicle_models)
  end
  
  it "should have one associated photo" do
    Category.should have_one(:category_photo).with_options(:dependent => :destroy)
  end
  
  it "should have a method 'general' which returns the default category named 'General'(if exists)" do
    Category.general.name.should eql('General')
  end
  
  it "should have a method 'thumb' which returns the thumbnail of the category photo" do
    @category.thumb.should eql('car_van.png')
    @general_category.thumb.should eql("/var/folders/ZQ/ZQni9yBXHcOR5b3eSzzrXE+++TI/-Tmp-/public/category_photos/3585/2020/130x80_hdfc_20feb_thumb.gif")
  end
  
end
