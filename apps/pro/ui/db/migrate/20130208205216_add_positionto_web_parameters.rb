class AddPositiontoWebParameters < ActiveRecord::Migration[4.2]
  def down
    change_table :web_parameters do |t|
      t.remove :position
    end
  end

  def up
    change_table :web_parameters do |t|
      t.integer :position, :null => false
    end
  end
end
