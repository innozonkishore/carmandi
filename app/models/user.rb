# == Schema Information
# Schema version: 20090811110741
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  firstname                 :string(255)
#  lastname                  :string(255)
#  email                     :string(255)
#  role_id                   :integer(4)
#  created_at                :datetime
#  updated_at                :datetime
#  crypted_password          :string(255)
#  salt                      :string(255)
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  reset_code                :string(255)
#  address                   :string(255)
#  phone_number              :string(255)
#  active                    :boolean(1)
#

require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  named_scope :representatives, :conditions => ["role_id = ?", Role.representative_id]
  named_scope :dealers, :conditions => ["role_id = ?", Role.dealer_id]

  belongs_to :role
  has_one :permission, :dependent => :destroy
  has_one :dealer, :dependent => :destroy
  has_many :saved_vehicles, :dependent => :destroy

  # validates_presence_of     :login
  #  validates_length_of       :login,    :within => 3..40
  #  validates_uniqueness_of   :login
  #  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
 
  # validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  # validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  validates_presence_of :role_id, :zipcode, :firstname#, :lastname#, :phone_number
  validates_associated :dealer

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation, :role_id, :firstname, :lastname, :username, :reset_code, :address, :phone_number, :fax_number, :zipcode, :active

  STATUS = { "Active" => true, "Inactive" => false}

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_by_email(email.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def is_admin?
    role_id == Role.admin_id
  end
  
  def is_representative?
    role_id == Role.representative_id
  end
  
  def is_dealer?
    role_id == Role.dealer_id
  end
  
  def is_private_seller?
    role_id == Role.private_seller_id
  end
  
  def is_buyer?
    role_id == Role.buyer_id
  end
  
  def is_dealer?
    role_id == Role.dealer_id
  end
  
  def has_permission?(permission)
    return true if self.is_admin?
    p = Permission.find(:first, :conditions => ["user_id = ? and #{permission} = true", self.id])
    return false if p.nil?
    return true
  end
  
  def create_reset_code
    @reset = true
    self.attributes = {:reset_code => Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )}
    save(false)
  end

  def recently_reset?
    @reset
  end

  def delete_reset_code
    self.attributes = {:reset_code => nil}
    save(false)
  end

  def fullname
     (firstname + " " + lastname)
  end
  

  protected
    


end
