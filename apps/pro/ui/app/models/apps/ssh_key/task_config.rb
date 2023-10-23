class Apps::SshKey::TaskConfig < Apps::TaskConfig
  include Wizards::TaskHelpers # we need #write_file_param_to_quickfile
  
  # set the name of the App#symbol used with this task config
  self.app_symbol = "ssh_key"

  #
  # Constants
  #
  # User can upload a key or choose a pre-existing key
  CRED_TYPES = {
    :user_supplied => "Enter a known credential pair",
    :stored        => "Choose an existing SSH key"
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

  # @attr [Array<String>] an array of IPs to NOT run against
  attr_accessor :blacklist_hosts

  # @attr [String] user-provided list of IPs, ranges, and tags
  attr_accessor :blacklist_string

  # @attr [String] cred_type user wants to upload or select a pre-existing SSH key
  attr_accessor :cred_type
  
  # @attr [String] key_file the uploaded SSH key file to use. Not present
  #   when the user is simply running validations.
  attr_accessor :key_file

  # @attr [String] username to attempt auth
  attr_accessor :ssh_username

  # @attr [Integer] Metasploit Credential Core
  attr_accessor :core
  
  # @attr [Array<String>] an array of IPs to run against
  attr_accessor :whitelist_hosts

  # @attr [String] user-provided list of IPs, ranges, and tags
  attr_accessor :whitelist_string


  #
  # Validations
  #

  validates :cred_type, :inclusion => { :in => CRED_TYPES.keys.map(&:to_s) }
  validates :ssh_username, :presence => true, :if => :cred_type_user_supplied?
  validate  :ssh_key_file_present_and_valid, :if => :cred_type_user_supplied_and_file_upload?
  validate  :whitelist_matches_host_in_workspace, on: :stand_alone
  validate  :whitelist_valid, on: :task_chain
  validate  :credential_core_valid, if: :should_validate_core_presence?
  
  def initialize(args={}, report_args={})
    # whitelist_hosts and blacklist_hosts come to us as a String with ranges
    expand_opts = {:workspace => args[:workspace], :current_user => args[:current_user]}
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

        #If Keyfile nil and previous core exists, use last uploaded file contents
        if key_file.nil? and args[:core_id].present?
          @core = Metasploit::Credential::Core.find(args[:core_id])
          key_file_content = @core.nil? ? nil : @core.private.try(:data)
        else
          key_file_content = key_file.try(:read)
        end


        credential_data = {
          workspace_id: args[:workspace_id] || @workspace.id,
          user_id: args[:current_user_id] || current_user.id,
          origin_type: :manual,
          private_data: key_file_content,
          private_type: :ssh_key,
          username: args[:ssh_username],
        }
        begin
          @core = create_credential(credential_data)
        rescue ActiveRecord::RecordInvalid => e
          @core = e.record
        end
        
      end
    end
  end

  # Sets default accessor values
  # @return self
  def set_defaults!
    @whitelist_string = workspace.boundary
    @cred_type = :user_supplied
    self
  end

  # @return [Hash["task_id"]] the id of the Quick Pentest Commander task
  def rpc_call(client)
    client.start_ssh_key_testing(config_to_hash)
  end

  # @return [Hash] that is passed to the module datastore
  def config_to_hash
    super.merge({
      'DS_WHITELIST_HOSTS' => whitelist_hosts.join(' '),
      'DS_BLACKLIST_HOSTS' => blacklist_hosts.join(' '),
      'DS_CRED_CORE_ID' => core.id
    })
  end

  private

  # TODO
  def cred_type_user_supplied_and_file_upload?
    cred_type_user_supplied? && !no_files
  end

  # Verifies key file is present, not empty, and has valid content
  def ssh_key_file_present_and_valid
    unless key_file && key_file.respond_to?(:rewind)
      errors.add :key_file, 'Key file must be specified'
      return
    end

    key_file.rewind
    if key_file.size == 0
      errors.add :key_file, 'Key file must not be empty'
    elsif !valid_ssh_key(key_file.read)
      errors.add :key_file, 'Key file must contain valid content'
    end

    key_file.rewind # so we can read() again later
  end

  # Verifies key file content is a well-formed SSH key
  # @param content [String] of key file
  def valid_ssh_key(content)
    begin
      Net::SSH::KeyFactory.load_data_private_key(content, nil, false)
    rescue OpenSSL::PKey::PKeyError, ArgumentError => error
      errors.add :key_file, "#{error.class} #{error}"
      return false
    end
  end

  # Only validate cores if:
  #   - an existing core was chosen by the user, OR
  #   - a manual core is specified by the user and the file inputs are sent in the requset
  def should_validate_core_presence?
    not cred_type_user_supplied? or not no_files
  end

  def credential_core_valid
    if core and not core.valid?
      core.errors.full_messages.each do |message|
        errors.add(:key_file, message)
      end
    elsif core.blank?
      errors.add(:core, :blank)
    end

  end
end
