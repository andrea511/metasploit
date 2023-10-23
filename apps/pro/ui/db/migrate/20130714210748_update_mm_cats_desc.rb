class UpdateMmCatsDesc < ActiveRecord::Migration[4.2]

  def up
    seed_dir = Pathname.new(__FILE__).parent.parent.join('seeds')

    # truncates & resets the auto_increment id for apps table
    ApplicationRecord.connection.execute("truncate table apps RESTART IDENTITY;")
    ApplicationRecord.connection.execute("truncate table app_categories RESTART IDENTITY;")
    ApplicationRecord.connection.execute("truncate table app_categories_apps RESTART IDENTITY;")
    # loads the data regarding apps from the csv data file
    CSV.foreach("#{seed_dir}/apps.csv", :headers => true) do |row|
      categories_array = JSON.parse(row['categories'].gsub("'", '"'))
      app = Apps::App.where(
        :name => row['name'],
        :description => row['description'],
        :rating => row['rating'],
        :symbol => row['symbol']
      ).first_or_create!
      categories_array.each do |cat|
        cat = Apps::AppCategory.where(name: cat).first_or_create
        unless app.app_categories.include? cat
          app.app_categories.push cat
          app.save
        end
      end
    end
  end

end
