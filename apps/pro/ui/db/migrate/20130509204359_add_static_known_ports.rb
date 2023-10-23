class AddStaticKnownPorts < ActiveRecord::Migration[4.2]
  def change
    create_table :known_ports do |t|
      t.integer :port, :null => false
      t.string :proto, :null => false, :default => 'tcp'
      t.string :name, :null => false
      t.text  :info
    end
    add_index :known_ports, :port
  end

end
