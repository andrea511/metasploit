class MovingHeadersAndCookiesToRequestGroups < ActiveRecord::Migration[4.2]
  def up
    change_table :web_headers do |t|
      t.remove_references :request  
      t.references :request_group, :null => false
    end
    
    change_table :web_cookies do |t|
      t.remove_references :request  
      t.references :request_group, :null => false
    end
  end

  def down
    change_table :web_cookies do |t|
      t.references :request  
      t.remove_references :request_group
    end
    
    change_table :web_headers do |t|
      t.references :request  
      t.remove_references :request_group
    end
  end
end
