class UpdatePndRating < ActiveRecord::Migration[4.2]
  def up
    seed_dir = Pathname.new(__FILE__).parent.parent.join('seeds')

    # truncates & resets the auto_increment id for apps table
    ApplicationRecord.connection.execute("truncate table apps RESTART IDENTITY;")
    # loads the data regarding apps from the csv data file
    CSV.foreach("#{seed_dir}/apps.csv", :headers => true) do |row|
      app = Apps::App.where(
        :name => row['name'],
        :description => row['description'],
        :rating => row['rating'],
        :symbol => row['symbol']
      ).first_or_create!
    end
  end
end
