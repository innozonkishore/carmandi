require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module UserSpecHelper
  def valid_user_attributes
    { :firstname => 'arun',
      :lastname => 'srivastava',
      :email => 'arun@gmail.com',
      :role_id => Role.dealer_id,
      :crypted_password => User.password_digest('dealer1','salt'),
      :salt => 'salt',
      :address => 'new delhi',
      :phone_number => '247466',
      :active => true,
      :username => 'arun',
      :fax_number => '3083904',
      :zipcode => '27348946',
      :password => 'dealer1',
      :password_confirmation => 'dealer1' }
      # :remember_token => NULL,
      # :remember_token_expires_at => NULL,
      # :reset_code => NULL, }
  end
end

describe 'Each User' do
  include UserSpecHelper
  fixtures :users, :roles
  
  # before do
  #   @category = categories(:household)
  # end
  
  it "should invalidate without postal code" do
    User.should need(:zipcode).using(valid_user_attributes)
  end
  
  it "should invalidate without a role" do
    User.should need(:role_id).using(valid_user_attributes)
  end
  
  it "should invalidate without firstname" do
    User.should need(:firstname).using(valid_user_attributes)
  end

  it 'must invalidate without an email' do
    User.should need(:email).using(valid_user_attributes)
  end
  
  it "should have a unique email" do
    user = User.new(valid_user_attributes)
    user.save.should eql(true)
    user2 = User.new(valid_user_attributes)
    user2.save.should eql(false)
  end
  
  it "should have length of email between 6 and 100" do
    user = User.new(valid_user_attributes)
    user.save.should eql(true)
    user.email = 'a@g.i'
    user.save.should eql(false)
    user.email = 'sdfsfjsdifjfiojiwehnsdefhewiuhrweifnjfeiuheiwuwiejwdndjvndfifuehuiheehrejjrjiowejmmvndfndjfnjfeiejjqq@gmail.com'
    user.save.should eql(false)
  end
  
  it "should be associated with a role" do
    User.should belong_to(:role)
  end
  
  it "should have different permissions" do
    User.should have_one(:permission).with_options(:dependent => :destroy)
  end
  
  it "should have one dealer information if user is a dealer" do
    User.should have_one(:dealer).with_options(:dependent => :destroy)
  end
  
  it "should have many saved vehicles" do
    User.should have_many(:saved_vehicles).with_options(:dependent => :destroy)
  end
  
  it "should have a named scope method 'representatives' which returns all users who are signed up as representatives" do
    User.should respond_to(:representatives)
    # User.representatives.size.should eql(1)
  end
  
  it "should have a named scope method 'dealers' which returns all users who are signed up as dealers" do
    User.should respond_to(:dealers)
    # User.dealers.size.should eql(1)
  end
  
  it "should have a method 'authenticate' which returns nil if user with given email and password doesn't exists else returns the user" do
    user = User.new(valid_user_attributes)
    user.save.should eql(true)
    User.authenticate('arun@gmail.com', 'dealer1').should eql(user)
    User.authenticate('bogus_user', 'no_password').should eql(nil)
  end
  
  it "should have a method 'email=' which writes the downcase value of email" do
    user = User.new(valid_user_attributes)
    user.email=('ABC@GMAIL.COM')#.should eql('abc@gmail.com')
    user.email.should eql('abc@gmail.com')
    user.email=()
    user.email.should eql(nil)
  end
  
  it "should have a method 'is_admin?' which returns true if current user is SWA" do
    user = User.new(valid_user_attributes)
    user.is_admin?.should eql(false)
    user.role_id = Role.admin_id
    user.is_admin?.should eql(true)  
  end
  
  it "should have a method 'is_representative?' which returns true if current user is representative" do
    user = User.new(valid_user_attributes)
    user.is_representative?.should eql(false)
    user.role_id = Role.representative_id
    user.is_representative?.should eql(true)  
  end
  
  it "should have a method 'is_dealer?' which returns true if current user is dealer" do
    user = User.new(valid_user_attributes)
    user.is_dealer?.should eql(true)
  end
  
  it "should have a method 'is_private_seller?' which returns true if current user is a private seller" do
    user = User.new(valid_user_attributes)
    user.is_private_seller?.should eql(false)
    user.role_id = Role.private_seller_id
    user.is_private_seller?.should eql(true)  
  end
  
  it "should have a method 'is_buyer?' which returns true if current user is a buyer" do
    user = User.new(valid_user_attributes)
    user.is_buyer?.should eql(false)
    user.role_id = Role.buyer_id
    user.is_buyer?.should eql(true)  
  end
  
  it "should have a method 'has_permission?' which returns true if current user has permission for passed-in action" do
    user = User.new(valid_user_attributes)
    user.has_permission?('manage_ad').should eql(false)
    user.role_id = Role.admin_id
    user.has_permission?('manage_ad').should eql(true)
  end
  
  it "should have a method 'create_reset_code' which creates the reset code if user has forgot his password" do
    user = User.new(valid_user_attributes)
    user.save
    user.create_reset_code.should eql(true)
  end
  
  it "should have a method 'recently_reset?' which returns true if user has requested to reset his password recently" do
    user = User.new(valid_user_attributes)
    user.save
    user.create_reset_code.should eql(true)
    user.recently_reset?.should eql(true)
  end
  
  it "should have a method 'delete_reset_code' which deletes the reset code after user has successfully reset his password" do
    user = User.new(valid_user_attributes)
    user.delete_reset_code
    user.reset_code.should eql(nil)
  end
  
  it "should have a method 'fullname' which returns the user's firsname and lastname appended together" do
    user = User.new(valid_user_attributes)
    user.fullname.should eql(user.firstname + " " + user.lastname)
  end
  
end