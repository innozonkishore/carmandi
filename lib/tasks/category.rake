namespace :data do
  desc "This adds default categories of vehicle"
  task :categories => :environment do
    
    [{:name => 'Sports'},
     {:name => 'Luxury'},
     {:name => 'Multi utility'}].each do |category|
      new_category = Category.new(category)
      if new_category.save
        puts I18n.translate(:category_created, :name => category[:name])
      else
        puts I18n.translate(:category_fail, :name => category[:name])
      end
    end
    
  end
end