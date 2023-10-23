require 'csv'

class AddingAppsSeedDataToDatabaseViaMigration < ActiveRecord::Migration[4.2]
  def up
    seed_dir = Pathname.new(__FILE__).parent.parent.join('seeds')

    # Creates static reference table of well-known ports,
    # used for firewall egress data
    # Truncate initially in case we have updated values
    ApplicationRecord.connection.execute("truncate table known_ports RESTART IDENTITY;")
    CSV.foreach("#{seed_dir}/known_ports.csv", :headers => true) do |row|
      port = row['port'].to_i
      name = row['name'].tr("'", "")
      info = row['info'].tr("'", "") || ''
      ApplicationRecord.connection.execute("INSERT INTO known_ports (port, name, info) VALUES(#{port}, \'#{name}\', \'#{info}\')\;")
    end

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

  def down
    ApplicationRecord.connection.execute("truncate table known_ports RESTART IDENTITY;")
    ApplicationRecord.connection.execute("truncate table apps RESTART IDENTITY;")
    ApplicationRecord.connection.execute("truncate table app_categories RESTART IDENTITY;")
    ApplicationRecord.connection.execute("truncate table app_categories_apps RESTART IDENTITY;")
  end
end
