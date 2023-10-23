require 'apps/firewall_egress/scan'

class Apps::FirewallEgress::TaskConfig < Apps::TaskConfig

  # Highest valid TCP port number
  MAX_PORT = 65535

  # set the name of the App#symbol used with this task config
  self.app_symbol = 'firewall_egress'

  #
  # Constants
  #

  # User can choose to use the default scan location, or a custom location
  DEFAULT_SCAN_TARGET_KEY = :default_scan_target
  SCAN_TARGET_TYPES = {
    DEFAULT_SCAN_TARGET_KEY => "Use default segmentation testing target (#{Apps::FirewallEgress::Scan::EGADZ_TARGET})",
    :custom_scan_target     => 'Use a custom segmentation testing target'
  }

  # User can choose to scan default nmap ports, or specify a custom range
  DEFAULT_PORT_SET_KEY = :default_nmap_port_set
  PORT_TYPES = {
    DEFAULT_PORT_SET_KEY => 'Use default nmap port set',
    :custom_range        => 'Use a custom port range'
  }

  # Available report type to render
  REPORT_TYPE = :mm_segment

  #
  # Attributes
  #

  # @attr_accessor [String] URL to use as the egress target
  attr_accessor :dst_host

  # @attr_accessor [Integer] the start port of the scan range
  attr_accessor :nmap_start_port

  # @attr_accessor [Integer] the end port of the scan range
  attr_accessor :nmap_stop_port

  # @attr_accessor [String] type of port scan
  # @see PORT_TYPES
  attr_accessor :port_type

  # @attr_accessor [String] type of scan location
  # @see SCAN_TARGET_TYPES
  attr_accessor :scan_target_type

  #
  # Validations
  #

  validates :nmap_start_port,
    :unless => :use_default_nmap_port_set?,
    :numericality => {
      :only_integer => true,
      :greater_than => 0,
      :less_than_or_equal_to => Apps::FirewallEgress::TaskConfig::MAX_PORT
    }

  validates :nmap_stop_port,
    :unless => :use_default_nmap_port_set?,
    :numericality => {
      :only_integer => true,
      :greater_than => 0,
      :less_than_or_equal_to => Apps::FirewallEgress::TaskConfig::MAX_PORT
    }

  validate :port_range_valid, :unless => :use_default_nmap_port_set?

  validates :dst_host, presence: true, unless: :use_default_scan_target?

  #
  # Instance methods
  #

  def initialize(args={}, report_args={})
    super

    @scan_target_type ||= DEFAULT_SCAN_TARGET_KEY
    if use_default_scan_target? || @dst_host.nil?
      @dst_host = Apps::FirewallEgress::Scan::EGADZ_TARGET
    end

    @port_type ||= DEFAULT_PORT_SET_KEY
  end

  def app_run_config
    {
      'scan_task' => {
        'use_nmap_default_port_set' => use_default_nmap_port_set?,
        'nmap_start_port' => nmap_start_port,
        'nmap_stop_port'  => nmap_stop_port,
        'dst_host'        => dst_host
      }
    }
  end

  # TODO: figure out how to hide this
  def rpc_call(client)
    client.start_firewall_egress_testing(config_to_hash)
  end

  private

  # @return [Boolean] user wants to use default nmap port set
  def use_default_nmap_port_set?
    self.port_type.to_s == DEFAULT_PORT_SET_KEY.to_s
  end

  # @return [Boolean] user wants to use default scan egress target
  def use_default_scan_target?
    self.scan_target_type.to_s == DEFAULT_SCAN_TARGET_KEY.to_s
  end

  # adds an Error if the start port < end port
  def port_range_valid
    if nmap_start_port.to_i > nmap_stop_port.to_i
      errors.add :nmap_start_port, 'invalid range'
    end
  end

end
