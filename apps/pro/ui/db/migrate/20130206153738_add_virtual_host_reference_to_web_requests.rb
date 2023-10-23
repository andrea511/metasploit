class AddVirtualHostReferenceToWebRequests < ActiveRecord::Migration[4.2]
  def down
    change_table :web_requests do |t|
      t.remove_references :virtual_host
    end
  end

  def up
    change_table :web_requests do |t|
      t.references :virtual_host, :null => false
    end
  end
end
