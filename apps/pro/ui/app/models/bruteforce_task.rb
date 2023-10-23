
class BruteforceTask < TaskConfig
  include ActiveModel::Validations
  include BruteforceTask::Addresses
  include BruteforceTask::Credentials
  include BruteforceTask::Limits
  include BruteforceTask::Payload
  include BruteforceTask::Scope
  include BruteforceTask::Services
  include BruteforceTask::Speed
  include BruteforceTask::SSH

  #
  # Methods
  #

  def allows_replay?
    true
  end

  def config_to_hash
    conf = {
      'DS_BLACKLIST_HOSTS'                           => blacklist.join(' '),
      'DS_BRUTEFORCE_GETSESSION'                     => brute_sessions,
      'DS_BRUTEFORCE_QUICKMODE_CREDS'                => quickmode_creds,
      'DS_BRUTEFORCE_RECOMBINE_CREDS'                => recombine_creds?,
      'DS_BRUTEFORCE_SCOPE'                          => fix_scope(scope),
      'DS_BRUTEFORCE_SERVICES'                       => brute_services.join(' '),
      'DS_BRUTEFORCE_SKIP_BLANK_PASSWORDS'           => skip_blank_passwords?,
      'DS_BRUTEFORCE_SPEED'                          => speed,
      'DS_DB_NAMES'                                  => db_names,
      'DS_DRY_RUN'                                   => dry_run?,
      'DS_DynamicStager'                             => dynamic_stager?,
      'DS_MAXGUESSESOVERALL'                         => max_guesses_overall,
      'DS_MAXGUESSESPERSERVICE'                      => max_guesses_per_service,
      'DS_MAXGUESSESPERUSER'                         => max_guesses_per_user,
      'DS_MAXMINUTESOVERALL'                         => max_minutes_overall,
      'DS_MAXMINUTESPERSERVICE'                      => max_minutes_per_service,
      'DS_MSSQL_WINDOWS_AUTH'                        => mssql_windows_auth?,
      'DS_PAYLOAD_METHOD'                            => connection.downcase,
      'DS_PAYLOAD_PORTS'                             => payload_ports,
      'DS_PAYLOAD_TYPE'                              => payload_type.downcase,
      'DS_PRESERVE_DOMAINS'                          => preserve_domains?,
      'DS_SMB_DOMAINS'                               => smb_domains,
      'DS_STOP_ON_SUCCESS'                           => stop_on_success?,
      'DS_USE_DEFAULT_CREDS'                         => use_default_creds,
      'DS_VERBOSE'                                   => verbose?,
      'DS_WHITELIST_HOSTS'                           => whitelist.join(" "),
      'username'                                     => username,
      'workspace'                                    => workspace.name,
      'DS_EnableStageEncoding'                       => stage_encoding?
    }

    if current_profile.settings['payload_prefer_https']
      conf['DS_EnableReverseHTTPS'] = true
    end

    if current_profile.settings['payload_prefer_http']
      conf['DS_EnableReverseHTTP'] = true
    end

    if macro_name.present?
      conf['DS_AutoRunScript'] = "post/pro/multi/macro MACRO_NAME='#{macro_name}'"
    end

    conf
  end


  boolean_attr_accessor :dry_run, :default => false
  boolean_attr_accessor :use_default_creds,  :default => false

  def initialize(attributes={})
    super(attributes)

    attribute_names = [
        :blacklist_string,
        :brute_services,
        :brute_sessions,
        :connection,
        :db_names,
        :dry_run,
        :dynamic_stager,
        :macro_name,
        :max_guesses_overall,
        :max_guesses_per_service,
        :max_guesses_per_user,
        :max_minutes_overall,
        :max_minutes_per_service,
        :mssql_windows_auth,
        :payload_ports,
        :payload_type,
        :preserve_domains,
        :quickmode_creds,
        :recombine_creds,
        :scope,
        :skip_blank_passwords,
        :smb_domains,
        :speed,
        :stop_on_success,
        :use_default_creds,
        :verbose,
        :whitelist_string
    ]

    self.blacklist = attributes[:blacklist]
    self.whitelist = attributes[:whitelist]

    attribute_names.each do |attribute_name|
      setter = "#{attribute_name}="
      value = attributes[attribute_name]

      send(setter, value)
    end

  end

  def rpc_call
    client.start_bruteforce(config_to_hash)
  end

  boolean_attr_accessor :verbose, :default => false

  private

  # Strip off the "only " tags for known and defaults. If this
  # gets any more complicated, just use an index mapping of
  # SCOPES to pick the right label -> scope.
  def fix_scope(str)
    if str =~ /([^\s]+) only$/
      $1
    elsif str.nil?
      DEFAULT_SCOPE
    else
      str
    end
  end

end

