class CreateWebRequestGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :web_request_groups do |t|
      t.timestamps null: false
    end
  end
end
