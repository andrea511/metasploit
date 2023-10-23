class CreateApps < ActiveRecord::Migration[4.2]
  def change
    create_table :apps do |t|
      t.string  :name
      t.text    :description
      t.float   :rating
    end
  end
end
