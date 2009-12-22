require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module RoleSpecHelper
  def valid_role_attributes
    { :name => 'bread role' }
  end
end

describe 'Each role' do
  include RoleSpecHelper
  fixtures :roles
  
  before do
    @admin = roles(:admin)
    @representative = roles(:representative)
    @dealer = roles(:dealer)
    @private_seller = roles(:private_seller)
    @buyer = roles(:buyer)
  end

  it 'must invalidate without a name' do
    Role.should need(:name).using(valid_role_attributes)
  end
  
  it "should have a unique name" do
    Role.should need(:name).to_be_unique.using(valid_role_attributes)
  end
  
  it "could belong to many users" do
    Role.should have_many(:users)
  end
  
  it "should have a method 'admin_id' which returns the id of admin role" do
    Role.admin_id.should eql(@admin.id)
  end
  
  it "should have a method 'representative_id' which returns the id of role named 'representative'" do
    Role.representative_id.should eql(@representative.id)
  end
  
  it "should have a method 'dealer_id' which returns the id of dealer role" do
    Role.dealer_id.should eql(@dealer.id)
  end
  
  it "should have a method 'private_seller_id' which returns the id of private seller role" do
    Role.private_seller_id.should eql(@private_seller.id)
  end
  
  it "should have a method 'buyer_id' which returns the id of buyer role" do
    Role.buyer_id.should eql(@buyer.id)
  end
  
end