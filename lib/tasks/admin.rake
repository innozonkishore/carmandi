namespace :data do
  desc "Creates a default website administrator (SWA)"
  task :admin => :environment do
   
    admin = User.new(:firstname => 'admin', :lastname => 'administrator', :email => 'admin@carmandi.ca', :role_id => Role.find_by_name('SWA').id, :password => 'pass123', :password_confirmation => 'pass123', :zipcode => 'V3S7K5', :address => '8496 148A St , Surrey, BC', :phone_number => '(604) 591-3392' , :fax_number => '(604) 888-5143')
    if existing = User.find_by_role_id(admin[:role_id])
      puts I18n.translate(:admin_present)
    else
      if admin.save!
        puts I18n.translate(:admin_created)
      else
        puts I18n.translate(:new_admin_fail)
      end
    end
      
  end
end