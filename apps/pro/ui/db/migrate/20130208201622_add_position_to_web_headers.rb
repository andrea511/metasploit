class AddPositionToWebHeaders < ActiveRecord::Migration[4.2]
  def down
    change_table :web_headers do |t|
      t.remove :position
    end
  end

  def up
    change_table :web_headers do |t|
      t.integer :position, :null => false
    end
  end
end
