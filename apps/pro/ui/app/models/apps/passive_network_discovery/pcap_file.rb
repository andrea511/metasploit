class Apps::PassiveNetworkDiscovery::PcapFile < ApplicationRecord
  self.table_name = :pnd_pcap_files
  
  belongs_to :task, :class_name => "Mdm::Task", :foreign_key => "task_id"
  belongs_to :loot, :class_name => "Mdm::Loot", :foreign_key => "loot_id"
  
  validates :task_id,  :presence => true
  validates :loot_id,  :presence => true
end
