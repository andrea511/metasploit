# The path column stores the uri path for the request
class AddPathToWebRequests < ActiveRecord::Migration[4.2]
  def down
    change_table :web_requests do |t|
      t.remove :path
    end
  end

  def up
    change_table :web_requests do |t|
      t.string :path, :null => false
    end
  end
end
