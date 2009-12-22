namespace :data do
  desc "Creates default ad locations"
  task :ad_location => :environment do
   
    [{:name => 'leftbar_home'},
     {:name => 'rightbar_home'},
     {:name => 'bottom_row_left_home'},
     {:name => 'bottom_row_middle_home'},
     {:name => 'bottom_row_right_home'},
     {:name => 'center_home'},
     {:name => 'leftbar_new_car'},
     {:name => 'rightbar_new_car'},
     {:name => 'bottom_row_left_new_car'},
     {:name => 'bottom_row_middle_new_car'},
     {:name => 'bottom_row_right_new_car'},
     {:name => 'leftbar_used_car'},
     {:name => 'rightbar_used_car'},
     {:name => 'bottom_row_left_used_car'},
     {:name => 'bottom_row_middle_used_car'},
     {:name => 'bottom_row_right_used_car'},
     {:name => 'leftbar_clearance_center'},
     {:name => 'rightbar_clearance_center'},
     {:name => 'bottom_row_left_clearance_center'},
     {:name => 'bottom_row_middle_clearance_center'},
     {:name => 'bottom_row_right_clearance_center'},
     {:name => 'leftbar_private_sales'},
     {:name => 'rightbar_private_sales'},
     {:name => 'bottom_row_left_private_sales'},
     {:name => 'bottom_row_middle_private_sales'},
     {:name => 'bottom_row_right_private_sales'},
     {:name => 'leftbar_sell_your_car'},
     {:name => 'rightbar_sell_your_car'},
     {:name => 'bottom_row_left_sell_your_car'},
     {:name => 'bottom_row_middle_sell_your_car'},
     {:name => 'bottom_row_right_sell_your_car'}      
     ].each do |location|
      ad_location = AdLocation.new(location)
      if existing = AdLocation.find_by_name(ad_location[:name])
        puts "Location with this name is already present"
      else
        if ad_location.save!
          puts "Location created with name #{ad_location[:name]}"
        else
          puts "Failed to create location named #{ad_location[:name]}"
        end
      end
    end
      
  end
end