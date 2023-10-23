class CreateWebVirtualHosts < ActiveRecord::Migration[4.2]
  def up
    create_table :web_virtual_hosts do |t|
      t.string :name, :null => false

      #
      # References
      #
      t.references :service, :null => false
    end

    add_index :web_virtual_hosts, [:service_id, :name], :unique => true
  end

  def down
    drop_table :web_virtual_hosts
  end
end
