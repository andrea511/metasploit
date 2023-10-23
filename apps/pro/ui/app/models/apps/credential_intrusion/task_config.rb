class Apps::CredentialIntrusion::TaskConfig < Apps::TaskConfig

  # set the name of the App#symbol used with this task config
  self.app_symbol = "credential_intrusion"

  #
  # Constants
  #

  REPORT_TYPE = :mm_auth

  STEPS = [
    :configure_scope,
    :configure_credentials,
    :generate_report
  ]

  #
  # Attributes
  #

  # @attr [Array<String>] a full list of IPs, expanded
  #   from the :blacklist_string attr
  attr_accessor :blacklist_hosts

  # @attr [String] user-provided list of un-expanded IPs,
  #   ranges, and tags.
  attr_accessor :blacklist_string

  # @attr [String] the connection type to use (auto/reverse/bind)
  attr_accessor :connection

  # @attr [Boolean] only gain one session from this MetaModule
  attr_accessor :limit_sessions

  # @attr [String] listener IP for reverse/auto payloads
  attr_accessor :payload_lhost

  # @attr [String] range of ports that the payload handler can use
  attr_accessor :payload_ports

  # @attr [String] type of payload (meterpreter/shell)
  attr_accessor :payload_type

  # @attr [Array<String>] a full list of IPs, expanded
  #   from the :whitelist_string attr
  attr_accessor :whitelist_hosts

  # @attr [String] user-provided list of un-expanded IPs,
  #   ranges, and tags.
  attr_accessor :whitelist_string

  attr_accessor :workspace

  #
  # Validations
  #

  validates :connection,    :presence => true
  validates :payload_type,  :presence => true
  validates :payload_ports, :presence => true
  validate  :whitelist_matches_host_in_workspace, on: :stand_alone
  validate  :whitelist_valid, on: :task_chain
  validate  :workspace_has_logins, on: :stand_alone

  def initialize(args={}, report_args={})
    @workspace = args[:workspace]
    # whitelist_hosts and blacklist_hosts come to us as a String with ranges
    expand_opts = {:workspace => args[:workspace]}
    @whitelist_hosts = Metasploit::Pro::AddressUtils.expand_ip_ranges(args[:whitelist_string] || '', expand_opts)
    @blacklist_hosts = Metasploit::Pro::AddressUtils.expand_ip_ranges(args[:blacklist_string] || '', expand_opts)

    # Pull args into attr_accessors
    # This has calls that assume whitelist_hosts exist, so
    # it needs to be after the {white,black}_list ivars
    super

    # coerce form-submitted truthy value to bool
    @limit_sessions = set_default_boolean(@limit_sessions, true)
  end

  # Sets default values for its attributes
  # @return self
  def set_defaults!
    @whitelist_string = @workspace.boundary
    @connection = "Auto"
    @payload_type = "Meterpreter"
    @payload_ports = "1024-65535"
    self
  end

  # @return [Hash["task_id"]] the id of the Quick Pentest Commander task
  def rpc_call(client)
    client.start_credential_intrusion(config_to_hash)
  end

  # @return [Hash] that is passed to the module
  def config_to_hash
    super.merge({
      'DS_WHITELIST_HOSTS' => whitelist_hosts.join(' '),
      'DS_BLACKLIST_HOSTS' => blacklist_hosts.join(' '),
      'DS_LIMIT_SESSIONS'  => limit_sessions,
      'DS_PAYLOAD_METHOD'  => connection.downcase,
      'DS_PAYLOAD_TYPE'    => payload_type.downcase,
      'DS_PAYLOAD_PORTS'   => payload_ports,
      'DS_PAYLOAD_LHOST'   => payload_lhost
    })
  end

  def workspace_has_logins
     if Metasploit::Credential::Login.in_workspace(workspace.id).count == 0
       errors.add(:whitelist_string, "No Logins for this Workspace")
     end
  end
end
