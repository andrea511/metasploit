require 'csv'

class FixAppHiddenFields < ActiveRecord::Migration[4.2]
  def up
    seed_dir = Pathname.new(__FILE__).parent.parent.join('seeds')

    Apps::App.reset_column_information
    CSV.foreach("#{seed_dir}/apps.csv", :headers => true) do |row|
      app = Apps::App.where(:symbol => row['symbol']).first_or_create(
        :name => row['name'],
        :description => row['description'],
        :rating => row['rating']
      )
      if row ['hidden'] == 'true'
        app.hidden = true
        app.save
      end
    end
  end

  def down
  end
end
