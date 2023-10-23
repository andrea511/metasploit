module Mdm::Loot::PndPcapFile
  extend ActiveSupport::Concern

  included do
    has_many :pnd_pcap_files, :class_name => "Apps::PassiveNetworkDiscovery::PcapFile"
  end
end
