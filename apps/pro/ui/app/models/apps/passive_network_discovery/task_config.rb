class Apps::PassiveNetworkDiscovery::TaskConfig < Apps::TaskConfig
  # set the name of the App#symbol used with this task config
  self.app_symbol = "passive_network"

  #
  # Constants
  #

  STEPS = [
    :configure_capture,
    :configure_filters,
    :generate_report
  ]

  REPORT_TYPE = :mm_pnd

  # TODO: Convert this over to NetworkInterface when it has support for friendly interface names
  INTERFACES = NetworkInterface.interfaces.sort

  INTERFACE_NAMES = begin
    h = {}
    INTERFACES.each do |interface|
      info = NetworkInterface.interface_info(interface)
      name = if info && info.has_key?('name')
        info['name']
      else
        interface
      end
      h[name] = interface
    end
    h
  end

  MAX_TOTAL_SIZE = 1024 * 1024 * 1024 * 2 # 2GB
  MAX_FILE_SIZE = 1024 * 1024 * 512     # 512MB
  MAX_TIMEOUT = 27 * 60 # 27 min

  NULL_DEVICE = 0 # used for testing the bpf filter validity without trying to open a device

  # tell pcap to capture the entire packet. if you only care about
  # e.g. the headers in the packet, you can limit this, but typical
  # users will just want to store the entire thing.
  SNAP_LENGTH_DEFAULT = 65535

  FILTER_TYPES = {
    'Select protocols from the following list' => :simple,
    'Manually enter a BPF string' => :manual
  }

  # BPF strings for some services, these will never show up on a switched network using this module
  SIMPLE_BPF = [
    {
      :label => "Internet Control Message Protocol (ICMP)",
      :protocol => "icmp"
    },
    {
      :label => "Remote Desktop Protocol (RDP)",
      :ports => [3389]
    },
    {
      :label => "Secure Shell (SSH)",
      :ports => [22]
    },
    {
      :label => "Server Message Block (SMB)",
      :ports => [135, 138, 139, 445]
    },
    {
      :label => "Simple Network Management Protocol (SNMP)",
      :protocol => 'udp',
      :ports => [161]
    },
    {
      :label => "Web Traffic (HTTP/HTTPS)",
      :protocol => 'tcp',
      :ports => [80, 8080, 443]
    },
    {
      :label => "Dynamic Host Configuration Protocol (DHCP)",
      :protocol => 'udp',
      :ports => [67, 68]
    },
    {
      :label => "Domain Name System (DNS)",
      :protocol => 'udp',
      :ports => [53]
    }
  ]

  #
  # Attributes
  #

  # @attr [String] the network interface name
  attr_accessor :interface

  # @attr [Integer] timeout in minutes
  attr_accessor :timeout

  # @attr [Integer] maximum pcap file size in bytes
  attr_accessor :max_file_size

  # @attr [Integer] maximum total disk space in bytes
  attr_accessor :max_total_size

  # @attr [Integer] ???
  attr_accessor :snaplength

  # @attr [String] custom Berkeley Packet Filter
  #   provided by the user.
  attr_accessor :bpf_string

  # Used only for the UI to render a choice
  # @attr [String] :custom/:simple whether user is manually entering bpf string
  attr_accessor :filter_type

  #
  # Validations
  #

  validates :max_file_size, :numericality => {
    :only_integer => true,
    :greater_than => 0
  }
  validates :max_total_size, :numericality => {
    :only_integer => true,
    :greater_than => 0
  }
  validates :snaplength, :numericality => {
    :only_integer => true,
    :greater_than => 0
  }
  validates :timeout, :numericality => {
    :only_integer => true,
    :greater_than => 0
  }
  validates :filter_type, :inclusion => { :in => FILTER_TYPES.values.map(&:to_s) }
  validate  :validate_bpf_string
  validate  :validate_interface

  def initialize(params={}, report_args={})
    super
    # we don't expose this to users, so default it for them everytime
    @snaplength ||= SNAP_LENGTH_DEFAULT
  end

  # Sets default values for accessors
  # @return self
  def set_defaults!
    @timeout        = 5
    @max_file_size  = 64 * 1024 * 1024 # 64 megs
    @max_total_size = 4 * 64 * 1024 * 1024 # 256 megs
    @snaplength     = SNAP_LENGTH_DEFAULT
    @bpf_string     = ""
    @filter_type    = :simple
    self
  end

  # @return [Hash["task_id"]] the id of the Mdm::Task spawned
  def rpc_call(client)
    client.start_passive_network_discovery(config_to_hash)
  end

  # @return [Hash] that is passed to the module
  def config_to_hash
    super.merge({
      "DS_INTERFACE"        =>  interface,
      "DS_TIMEOUT"          =>  timeout.to_i * 60,
      "DS_MAX_FILE_SIZE"    =>  max_file_size.to_i,
      "DS_MAX_CAPTURE_SIZE" =>  max_total_size.to_i,
      "DS_SNAPLENGTH"       =>  snaplength.to_i,
      "DS_BPF"              =>  bpf_string
    })
  end

  private

  def validate_bpf_string
    if @bpf_string.present?
      begin
        pcap = PCAPRUB::Pcap.open_dead(NULL_DEVICE, 65535).compile(@bpf_string)
      rescue Exception => e
        errors.add :bpf_string, e.message.sub(/^\: /, '')
      end
    end
  end

  def validate_interface
    if not INTERFACES.include?(@interface)
      errors.add :interface, 'is invalid'
    end
  end
end
