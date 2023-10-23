class Apps::SinglePassword::TaskConfig < Apps::TaskConfig

  # set the name of the App#symbol used with this task config
  self.app_symbol = "single_password"

  #
  # Constants
  #

  STEPS = [
    :configure_scope,
    :configure_services,
    :configure_credentials,
    :generate_report
  ]

  CRED_TYPES = {
    :user_supplied => "Enter a known credential pair",
    :stored => "Choose an existing credential pair"
  }

  # Passed to the Report
  REPORT_TYPE = :mm_auth

  #
  # Attributes
  #

  # @attr [String] username to attempt to auth with
  attr_accessor :auth_username

  # @attr_reader [Array<String>] an array of IPs to NOT run against
  attr_reader :blacklist_hosts

  # @attr [String] user-provided list of IPs, ranges, and tags
  attr_accessor :blacklist_string

  # @attr [String] use user-supplied of pre-existing cred (see CRED_TYPES)
  attr_accessor :cred_type

  # @attr [Integer] Metasploit Credential Core
  attr_accessor :core
  
  # @attr [String] domain (optional)
  attr_accessor :domain

  # @attr [String] password to attempt to auth with
  attr_accessor :password

  # @attr [Array<String>] names of services to attempt to connect to
  attr_accessor :services

  # @attr_reader [Array<String>] an array of IPs to run against
  attr_reader :whitelist_hosts

  # @attr [String] user-provided list of IPs, ranges, and tags
  attr_accessor :whitelist_string

  #
  # Validations
  #
  validates :cred_type, :inclusion => { :in => CRED_TYPES.keys.map(&:to_s) }
  validates :auth_username, :presence => true, :if => :cred_type_user_supplied?
  validates :password, :presence => true, :if => :cred_type_user_supplied?
  validate  :services_valid
  validate  :whitelist_matches_host_in_workspace, on: :stand_alone
  validate  :whitelist_valid, on: :task_chain

  def initialize(args={}, report_args={})
    # whitelist_hosts and blacklist_hosts come to us as a String with ranges
    expand_opts = {:workspace => args[:workspace]}
    @whitelist_hosts = Metasploit::Pro::AddressUtils.expand_ip_ranges(args[:whitelist_string] || '', expand_opts)
    @blacklist_hosts = Metasploit::Pro::AddressUtils.expand_ip_ranges(args[:blacklist_string] || '', expand_opts)

    # Pull args into attr_accessors
    # This has calls that assume whitelist_hosts exist, so
    # it needs to be after the {white,black}_list ivars
    super
    
    if args[:core_id].present? and not cred_type_user_supplied?
      @core = Metasploit::Credential::Core.find(args[:core_id])
    elsif cred_type_user_supplied?
      unless no_files
        credential_data = {
          workspace_id: args[:workspace_id] || @workspace.id,
          user_id: args[:current_user_id] || current_user.id,
          origin_type: :manual,
          private_data: args[:password],
          private_type: :password,
          username: args[:auth_username]
        }
        
        if args[:domain].present?
          credential_data.merge!({
            realm_key: Metasploit::Model::Realm::Key::ACTIVE_DIRECTORY_DOMAIN,
            realm_value: args[:domain]
          })
        end
        
        begin
          @core = create_credential(credential_data)
        rescue ActiveRecord::RecordInvalid => e
          @core = e.record
        end

      end
    end
    
  end

  # sets default attr values
  # @return self
  def set_defaults!
    @services = BruteforceTask::Services::SERVICES
    @cred_type = :user_supplied
    @whitelist_string = @workspace.boundary
    super
  end

  # @return [Hash["task_id"]] the id of the Quick Pentest Commander task
  def rpc_call(client)
    client.start_single_password_testing(config_to_hash)
  end

  # @return [Hash] that is passed to the module
  def config_to_hash
    super.merge({
      'DS_WHITELIST_HOSTS' => whitelist_hosts.join(' '),
      'DS_BLACKLIST_HOSTS' => blacklist_hosts.join(' '),
      'DS_CRED_CORE_ID'    => core.id,
      'DS_SERVICES' => services.join(',')
    })
  end

  private
  
  # Validation method to check user-provided services
  def services_valid
    services.each do |svc|
      unless BruteforceTask::Services::SERVICES.include? svc
        errors.add :services, "#{svc} is not a valid target service"
      end
    end
  end
   
end
