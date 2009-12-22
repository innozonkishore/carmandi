namespace :data do
  desc "This adds 5 default roles ie; Dealer, Buyer, Private seller, SWA and CarMandi representative"
  task :roles => :environment do
    
    [{:name => 'Dealer'},
     {:name => 'Buyer'},
     {:name => 'Private seller'},
     {:name => 'SWA'},
     {:name => 'representative'}].each do |role|
      if existing = Role.find_by_name(role[:name])
        puts "There is already a role named #{role[:name]}"
      else
        new_role = Role.new(role)
        if new_role.save
          puts I18n.translate(:role_created, :role_name => role[:name])
        else
          puts I18n.translate(:new_role_fail, :role_name => role[:name])
        end
      end
    end
    
  end
end