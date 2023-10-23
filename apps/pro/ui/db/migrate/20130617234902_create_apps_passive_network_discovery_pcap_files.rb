class CreateAppsPassiveNetworkDiscoveryPcapFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :pnd_pcap_files do |t|
      t.integer :task_id
      t.integer :loot_id
      t.string :status
      t.timestamps null: false
    end
  end
end
