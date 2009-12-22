class PaymentInfo < ActiveRecord::Base
  
  validates_presence_of :firstname, :lastname, :address, :city, :state
  
end
