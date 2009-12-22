namespace :data do
  desc "This adds default vehicle_make and vehicle_model data to db"
  task :make_model => :environment do
    
    [ {:name => 'Acura', :url => "http://www.acura.ca"},
      {:name => 'Aston Martin', :url => "http://www.astonmartin.com/"},
      {:name => 'Audi', :url => "http://www.audi.ca/audi/ca/en2.html"},
      {:name => 'Bentley', :url => "http://www.bentleymotors.com/default.aspx"},
      {:name => 'BMW', :url => "http://www.bmw.ca/ca/en/"},
      {:name => 'Buick', :url => "http://www.gm.ca/gm/english/vehicles/buick/"},
      {:name => 'Cadillac', :url => "http://www.gm.ca/gm/english/vehicles/cadillac/"},
      {:name => 'Chevrolet', :url => "http://www.gm.ca/gm/english/vehicles/chevrolet/"},
      {:name => 'Chrysler', :url => "http://www.chryslercanada.ca/en/index.php"},
      {:name => 'Dodge', :url => "http://www.dodge.ca/en/"},
      {:name => 'Ferrari', :url => "http://www.ferrari.com/English/Pages/Home.aspx"},
      {:name => 'Ford', :url => "http://www.ford.ca"},
      {:name => 'GMC', :url => "http://www.gmc.ca"},
      {:name => 'Honda', :url => "http://www.honda.ca"},
      {:name => 'HUMMER', :url => "http://www.gm.ca/gm/english/vehicles/hummer/"},
      {:name => 'Hyundai', :url => "http://www.hyundaicanada.com/Default.aspx"},
      {:name => 'Infiniti', :url => "http://www.infiniti.ca/en/index.html"},
      {:name => 'Isuzi', :url => ""},
      {:name => 'Jaguar', :url => "http://www.jaguar.ca/ca/en/homepage.htm"},
      {:name => 'Jeep', :url => "http://www.jeep.ca/en/"},
      {:name => 'Kia', :url => "http://www.kia.ca/"},
      {:name => 'Lamborghini', :url => "http://www.lamborghini.ca/"},
      {:name => 'Land Rover', :url => "http://www.landrover.ca/ca/en/home.htm"},
      {:name => 'Lexus', :url => "http://www.lexus.ca/"},
      {:name => 'Lincoln', :url => "http://www.lincolncanada.com/app/li/index.do"},
      {:name => 'Lotus', :url => "http://www.lotuscars.com/"},
      {:name => 'Maserati', :url => "http://www.maserati.com/maserati/en/en/index.html"},
      {:name => 'Maybach', :url => "http://www.maybachusa.com/index.php"},
      {:name => 'Mazda', :url => "http://www.mazda.ca/root.asp?lang=eng"},
      {:name => 'Mercedes-Benz', :url => "http://www.mercedes-benz.ca/index.cfm?Language=english&id=285"},
      {:name => 'Mercury', :url => "http://www.mercuryvehicles.com/"},
      {:name => 'MINI', :url => "http://www.mini.ca/"},
      {:name => 'Mitsubishi', :url => "http://www.mitsubishi-motors.ca/Home.aspx"},
      {:name => 'Nissan', :url => "http://www.nissan.ca/en/"},
      {:name => 'Pontiac', :url => "http://www.gm.ca/gm/english/vehicles/pontiac/"},
      {:name => 'Porsche', :url => "http://www.porsche.com/canada/en/"},
      {:name => 'Rolls-Royce', :url => "http://www.rolls-roycemotorcars.com/hi-band/swf/index.html"},
      {:name => 'Saab', :url => "http://www.gm.ca/ss/gm/homepage.do?lang=en_CA&brand=saab"},
      {:name => 'Saturn', :url => "http://www.gm.ca/ss/gm/homepage.do?lang=en_CA&brand=saturn"},
      {:name => 'Scion', :url => "http://www.scion.com/"},
      {:name => 'Smart', :url => "http://www.thesmart.ca/index.cfm?ID=4720"},
      {:name => 'Subaru', :url => "http://www.subaru.ca/WebPage.aspx?WebSiteID=282"},
      {:name => 'Suzuki', :url => "http://www.suzuki.ca/automotive?province=ON&culture=en-CA"},
      {:name => 'Tata', :url => "http://www.tatamotors.com"},
      {:name => 'Toyota', :url => "http://www.toyota.ca/cgi-bin/WebObjects/WWW.woa/wa/vp?vp=Home&language=english"},
      {:name => 'Volkswagen', :url => "http://www.vw.ca/vwcms/master_public/virtualmaster/en_ca_bc.html"},
      {:name => 'Volvo', :url => "http://www.volvocanada.com/"}
     ].each do |vehicle_make|
       if VehicleMake.find_by_name(vehicle_make[:name])
         puts I18n.translate(:vehicle_make_present, :name => vehicle_make[:name])
       else
         new_vehicle_make = VehicleMake.new(vehicle_make)
         if new_vehicle_make.save
           puts I18n.translate(:vehicle_make_created, :name => vehicle_make[:name])
         else
           puts I18n.translate(:vehicle_make_fail, :name => vehicle_make[:name])
         end
       end
     end
    
    [ {:name => 'City', :vehicle_make_id => VehicleMake.find_by_name('Honda').id},
      {:name => 'Civic', :vehicle_make_id => VehicleMake.find_by_name('Honda').id},
      {:name => 'Fiesta', :vehicle_make_id => VehicleMake.find_by_name('Ford').id},
      {:name => 'Ikon', :vehicle_make_id => VehicleMake.find_by_name('Ford').id},
      {:name => 'Indica', :vehicle_make_id => VehicleMake.find_by_name('Tata').id},
      {:name => 'Nano', :vehicle_make_id => VehicleMake.find_by_name('Tata').id}
     ].each do |vehicle_model|
       new_vehicle_model = VehicleModel.new(vehicle_model)
       if new_vehicle_model.save
         puts I18n.translate(:vehicle_model_created, :name => vehicle_model[:name])
       else
         puts I18n.translate(:vehicle_model_fail, :name => vehicle_model[:name])
       end
     end
     
  end
end