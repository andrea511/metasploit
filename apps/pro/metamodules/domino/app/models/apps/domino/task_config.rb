class Apps::Domino::TaskConfig < Apps::TaskConfig

  # set the name of the App#symbol used with this task config
  self.app_symbol = "domino"

  # Use the new-style task_presenter hotness
  self.use_task_presenter = true

  #
  # Constants
  #

  # Passed to the Report
  REPORT_TYPE = :mm_domino

  STEPS = [
    :select_initial_host,
    :scope,
    :settings,
    :generate_report
  ]


  # @attr [Array<String>] a full list of IPs, expanded
  #   from the :whitelist_string attr
  attr_accessor :whitelist_hosts

  # @attr [String] user-provided list of un-expanded IPs,
  #   ranges, and tags to attack
  attr_accessor :whitelist_string

  # @attr [Array<String>] a full list of IPs, expanded
  #   from the :blacklist_string attr
  attr_accessor :blacklist_hosts

  # @attr [String] user-provided list of un-expanded IPs,
  #   ranges, and tags to AVOID attacking
  attr_accessor :blacklist_string

  # @attr [Array<String>] a list of high value IPs
  attr_accessor :high_value_hosts

  # @attr [String] user-provided list of un-expanded IPs,
  #   ranges, and tags to tag as high value Hosts
  attr_accessor :high_value_hosts_string

  # @attr [String] user-provided list of comma-separated
  #   tag names to tag high value Hosts
  attr_accessor :high_value_tags_string

  # @attr [Integer] the id of the initial host
  attr_accessor :initial_host_id

  # @attr [Integer] the id of the initial login
  attr_accessor :initial_login_id

  # @attr [Integer] the id of the initial session
  attr_accessor :initial_session_id

  # @attr [String] the connection type to use (auto/reverse/bind)
  attr_accessor :connection

  # @attr [Boolean] clean up the sessions after execution
  attr_accessor :cleanup_session

  # @attr [String] listener IP for reverse/auto payloads
  attr_accessor :payload_lhost

  # @attr [String] range of ports that the payload handler can use
  attr_accessor :payload_ports

  # @attr [String] type of payload (meterpreter/shell)
  attr_accessor :payload_type

  # @attr [Boolean] enable dynamic stagers
  attr_accessor :dynamic_stagers

  # @attr [Integer] maximum number of iterations
  attr_accessor :num_iterations

  # @attr [Integer] maximum time for the entire run
  attr_accessor :overall_timeout
  attr_accessor :overall_timeout_hh
  attr_accessor :overall_timeout_mm
  attr_accessor :overall_timeout_ss

  # @attr [Integer] maximum time to wait for a response from a service
  attr_accessor :service_timeout

  #
  # Validations
  #

  validates :connection,    :presence => true
  validates :payload_type,  :presence => true
  validates :payload_ports, :presence => true
  validate  :whitelist_valid
  validate  :blacklist_valid
  validate  :high_value_hosts_valid
  validate  :validate_initial_attack

  def initialize(args={}, report_args={})
    # whitelist_hosts and blacklist_hosts come to us as a String with ranges
    expand_opts = {:workspace => args[:workspace]}
    @whitelist_hosts = Metasploit::Pro::AddressUtils.expand_ip_ranges(args[:whitelist_string] || '', expand_opts)
    @blacklist_hosts = Metasploit::Pro::AddressUtils.expand_ip_ranges(args[:blacklist_string] || '', expand_opts)
    @high_value_hosts = Metasploit::Pro::AddressUtils.expand_ip_ranges(args[:high_value_hosts_string] || '', expand_opts)

    # Pull args into attr_accessors
    # This has calls that assume whitelist_hosts exist, so
    # it needs to be after the {white,black}_list ivars
    super

    @overall_timeout_ss = @overall_timeout_ss.to_i
    @overall_timeout_mm = @overall_timeout_mm.to_i
    @overall_timeout_hh = @overall_timeout_hh.to_i
    @overall_timeout = @overall_timeout_ss + @overall_timeout_mm*60 + @overall_timeout_hh*60*60
    if @initial_login_id.present?
      @initial_login_id = @initial_login_id.to_i
    end

    if @initial_session_id.present?
      @initial_session_id = @initial_session_id.to_i
    end

    if @initial_host_id.present?
      @initial_host_id = @initial_host_id.to_i
    end

    if @num_iterations.present?
      @num_iterations = @num_iterations.to_i
    else
      # kill the empty-string case
      @num_iterations = nil
    end

    @service_timeout = @service_timeout.to_i

    # coerce form-submitted truthy value to bool
    @cleanup_session = set_default_boolean(@cleanup_session, true)
    @dynamic_stagers = set_default_boolean(@dynamic_stagers, false)
  end

  def set_defaults!
    @whitelist_string = @workspace.boundary
    @connection = "Auto"
    @payload_type = "Meterpreter"
    @payload_ports = "1024-65535"
    @overall_timeout_ss = 0
    @overall_timeout_mm = 0
    @overall_timeout_hh = 4
    @overall_timeout = 4*60*60
    @service_timeout = 60
    self
  end

  def validate_initial_attack
    if @initial_login_id.nil? and @initial_session_id.nil?
      errors.add :initial_attack, "must select an initial login or session"
    end
  end

  def initial_attack_type
    if @initial_login_id.present?
      'login'
    elsif @initial_session_id.present?
      'session'
    else
      nil
    end
  end

  def blacklist_valid
    blacklist_hosts.each do |ip|
      next if valid_ip_or_range?(ip)
      errors.add :blacklist_string,  "Invalid address: #{ip}"
    end
  end

  def high_value_hosts_valid
    @high_value_hosts.each do |ip|
      next if valid_ip_or_range?(ip)
      errors.add :high_value_hosts_string,  "Invalid address: #{ip}"
    end
  end

  def num_iterations_valid
    if num_iterations.present? and num_iterations !~ /\A\d+\Z/
      errors.add :num_iterations,  "Invalid number of iterations"
    end
  end

  # @return [Hash["task_id"]] the id of the Quick Pentest Commander task
  def rpc_call(client)
    client.start_domino_metamodule(config_to_hash)
  end

  def task_presenter
    :domino
  end

  # @return [Hash] that is passed to the module
  def config_to_hash
    super.merge({
      'initial_attack_type'  => initial_attack_type,
      'initial_host_id'      => @initial_host_id,
      'initial_session_id'   => @initial_session_id,
      'initial_login_id'     => @initial_login_id,
      'target_addresses'     => @whitelist_hosts,
      'excluded_addresses'   => @blacklist_hosts,
      'high_value_addresses' => @high_value_hosts,
      'high_value_tags'      => @high_value_tags_string.split(/\s*,\s*/).map(&:strip),
      'payload' => {
        'payload_type'  => @payload_type,
        'connection'    => @connection,
        'payload_ports' => @payload_ports,
        'payload_lhost' => @payload_lhost
      },
      'DS_PAYLOAD_METHOD' => @connection,
      'DS_PAYLOAD_TYPE'   => @payload_type,
      'DS_PAYLOAD_PORTS'  => @payload_ports,
      'DS_PAYLOAD_LHOST'  => @payload_lhost,
      'DS_DynamicStager'  => @dynamic_stagers,
      'cleanup_sessions'  => @cleanup_session,
      'max_iterations'    => @num_iterations, #unlimited
      'overall_timeout'   => @overall_timeout, #seconds
      'service_timeout'   => @service_timeout  # seconds
    })
  end

end
