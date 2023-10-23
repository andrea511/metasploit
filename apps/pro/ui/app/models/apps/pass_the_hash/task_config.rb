class Apps::PassTheHash::TaskConfig < Apps::TaskConfig

  # set the name of the App#symbol used with this task config
  self.app_symbol = "pass_the_hash"

  #
  # Constants
  #

  # User can enter a hash or choose a pre-existing hash
  CRED_TYPES = {
    :user_supplied => "Enter a known credential pair",
    :stored => "Choose an existing replayable hash"
  }

  # Passed to the Report
  REPORT_TYPE = :mm_auth

  # Each tab on the multi-page form gets its own "step"
  STEPS = [
    :configure_scope,
    :configure_credentials,
    :generate_report
  ]

  #
  # Attributes
  #

  attr_accessor :blacklist_hosts
  attr_accessor :blacklist_string
  attr_accessor :cred_type
  attr_accessor :domain
  attr_accessor :hash
  attr_accessor :smb_username

  # @attr [Integer] Metasploit Credential Core
  attr_accessor :core
  
  attr_accessor :whitelist_hosts
  attr_accessor :whitelist_string

  #
  # Validations
  #

  validates :cred_type, :inclusion => { :in => CRED_TYPES.keys.map(&:to_s) }
  validates :smb_username, :presence => true, :if => :cred_type_user_supplied?
  validates :hash, :presence => true, :if => :cred_type_user_supplied?
  validate  :whitelist_matches_host_in_workspace, on: :stand_alone
  validate  :whitelist_valid, on: :task_chain
  validate  :hash_valid?
  validate  :credential_core_valid, if: :should_validate_core_presence?
  
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
      @hash = args[:hash]
      unless no_files
        if args[:hash] =~ Metasploit::Credential::PostgresMD5::DATA_REGEXP
          private_type = :postgres_md5
        else
          private_type = :ntlm_hash
        end
        credential_data = {
          workspace_id: args[:workspace_id] || @workspace.id,
          user_id: args[:current_user_id] || current_user.id,
          origin_type: :manual,
          private_data: args[:hash],
          private_type: private_type,
          username: args[:smb_username],
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
    @domain = 'WORKGROUP'
    @whitelist_string = @workspace.boundary
    @cred_type = :user_supplied
    self
  end

  # @return [Hash["task_id"]] the id of the Quick Pentest Commander task
  def rpc_call(client)
    client.start_pass_the_hash(config_to_hash)
  end

  # @return [Hash] that is passed to the module datastore
  def config_to_hash
    super.merge({
      'DS_WHITELIST_HOSTS' => whitelist_hosts.join(' '),
      'DS_BLACKLIST_HOSTS' => blacklist_hosts.join(' '),
      'DS_CRED_CORE_ID'    => core.id
    })
  end

  def should_validate_core_presence?
    (not cred_type_user_supplied? or not no_files)
  end
  
  def credential_core_valid
    if core and not core.valid?
      core.errors.full_messages.each do |message|
        errors.add(:core, message)
      end
    elsif core.blank?
      errors.add(:core, :blank)
    end

  end

  def hash_valid?
    unless Metasploit::Credential::NTLMHash::DATA_REGEXP.match(@hash) || Metasploit::Credential::PostgresMD5::DATA_REGEXP.match(@hash)
      errors.add(:core, "Invalid Hash Format Supplied")
    end
  end
  
end
