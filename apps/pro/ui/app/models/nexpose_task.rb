class NexposeTask < TaskConfig

  SCAN_TEMPLATE_LABELS = [ "Penetration Test Audit", "Full Audit", "Exhaustive Audit", "Discovery", "Aggressive Discovery", "DoS Audit" ]
  SCAN_TEMPLATES       = %W{pentest-audit full-audit exhaustive-audit discovery aggressive-discovery dos-audit }

  CREDENTIAL_TYPES_LABELS = [ "Windows/CIFS", "NTLM Hash (or LM:NTLM)", "Secure Shell", "Telnet", "HTTP", "FTP", "SNMP", "POP3" ]
  CREDENTIAL_TYPES        = %W{cifs cifshash ssh telnet http ftp snmp pop}

#
# We need to hide/show fields based on type to do this correctly
#
=begin
               'cvs' : { 'realm': null, 'unameconcat': 'User name', 'passwd': 'Password' },
               'ftp' : { 'realm': null, 'unameconcat': 'User name', 'passwd': 'Password' },
               'http' : { 'realm': 'Realm', 'unameconcat': 'User name', 'passwd': 'Password' },
               'httpheaders' : { },
               'htmlform' : { },
               'as400' : { 'realm': 'Domain', 'unameconcat': 'User name', 'passwd': 'Password' },
               'notes' : { 'realm': null, 'unameconcat': null, 'passwd': 'Notes ID password' },
               'tds' : { 'realm': 'Login database', 'undomainWinAuth': 'Windows Authentication', 'unamedomain': 'Domain', 'unameconcat': 'User Name', 'passwd': 'Password' },
               'sybase' : { 'realm': 'Login database', 'undomainWinAuth': 'Windows Authentication', 'unamedomain': 'Domain', 'unameconcat': 'User name', 'passwd': 'Password' },
               'cifs' : { 'realm': 'Domain', 'unameconcat': 'User name', 'passwd': 'Password' },
               'oracle' : { 'realm': 'SID', 'unameconcat': 'User name', 'passwd': 'Password' },
               'mysql' : { 'realm' : 'Database', 'unameconcat': 'User name', 'passwd': 'Password' },
               'db2' : { 'realm' : 'Database', 'unameconcat': 'User name', 'passwd': 'Password' },
               'pop' : { 'realm': null, 'unameconcat': 'User name', 'passwd': 'Password' },
               'remote execution' : { 'realm': null, 'unameconcat': 'User name', 'passwd': 'Password' },
               'snmp' : { 'realm': null, 'unameconcat': null, 'passwd': 'Community name' },
               'ssh' : { 'realm': null, 'unameconcat': 'User name', 'passwd': 'Password' },
               'telnet' : { 'realm': null, 'unameconcat': 'User name', 'passwd': 'Password' }
=end


  attr_accessor :whitelist, :blacklist, :use_pass_the_hash_creds, :pthcred, :scan_template, :nexpose_console, :consoles
  attr_accessor :nexpose_creds_type, :nexpose_creds_user, :nexpose_creds_pass, :nexpose_purge_site, :custom_template
  attr_accessor :autotag_os
  
  # skips the validation for IP addresses passed in
  attr_accessor :skip_host_validity_check

  # makes valid? return false if 
  # I'm not sure why this behavior wasnt there, if nexpose site has some
  # default boundary that should get scanned
  attr_accessor :ensure_whitelist_present

  def initialize(attributes)
    super(attributes)

    @whitelist = attributes[:whitelist] || []
    @blacklist = attributes[:blacklist] || []
    @use_pass_the_hash_creds = set_default_boolean(attributes[:use_pass_the_hash_creds], false)
    @pthcred = attributes[:pthcred] || ''
    @scan_template = attributes[:scan_template]
    @custom_template = attributes[:custom_template]
    @skip_host_validity_check = set_default_boolean(attributes[:skip_host_validity_check], false)
    @ensure_whitelist_present = set_default_boolean(attributes[:ensure_whitelist_present], false)

    @console = if attributes[:nexpose_console].present?
      Mdm::NexposeConsole.find_by_name(attributes[:nexpose_console])
    elsif attributes[:nexpose_console_id].present?
      Mdm::NexposeConsole.find_by_id(attributes[:nexpose_console_id])
    end

    if @console.present?
      @nexpose_host = @console.address
      @nexpose_port = @console.port
      @nexpose_user = @console.username
      @nexpose_pass = @console.password
      @nexpose_cid  = @console.id.to_s
    end

    @nexpose_creds_type = attributes[:nexpose_creds_type]
    @nexpose_creds_user = attributes[:nexpose_creds_user]
    @nexpose_creds_pass = attributes[:nexpose_creds_pass]

    @nexpose_purge_site = set_default_boolean(attributes[:nexpose_purge_site], false)

    @whitelist = tags_and_addresses(@whitelist)
    @blacklist = tags_and_addresses(@blacklist)

    if attributes[:whitelist_string]
      @whitelist = tags_and_addresses(attributes[:whitelist_string].split(/\s+/))
    end

    if attributes[:blacklist_string]
      @blacklist = tags_and_addresses(attributes[:blacklist_string].split(/\s+/))
    end

    if attributes[:pthcred_string]
      @pthcred = attributes[:pthcred_string]
    end

    if @custom_template.to_s.strip.length > 0
      @scan_template = @custom_template
    end

    @consoles = Mdm::NexposeConsole.where(enabled: true).collect(&:name)
    @autotag_os = set_default_boolean(attributes[:autotag_os], false)
  end

  def whitelist_string
    whitelist.join("\n")
  end

  def blacklist_string
    blacklist.join("\n")
  end

  def pthcred_string
    pthcred
  end

  def nexpose_credentials
    if nexpose_creds_type.to_s.strip.length > 0 and nexpose_creds_user.to_s.strip.length > 0 and nexpose_creds_pass.to_s.strip.length > 0
      [nexpose_creds_type, nexpose_creds_user, nexpose_creds_pass].join("\x01")
    else
      ''
    end
  end

  def valid?
    if @console.nil?
      @error = "Nexpose Console must be selected"
      return false
    end

    if @nexpose_user.nil? or @nexpose_user.empty?
      @error = "Username is required"
      return false
    end

    if @nexpose_pass.nil? or @nexpose_pass.empty?
      @error = "Password is required"
      return false
    end

    if @nexpose_host.nil? or @nexpose_host.empty?
      @error = "Nexpose Server is required"
      return false
    end

    if @nexpose_cid.nil? or @nexpose_cid.empty?
      @error = "Nexpose Console ID is required"
      return false
    end

    unless (1..65535).include?(@nexpose_port.to_i)
      @error = "Invalid Nexpose Port"
      return false
    end

    if @ensure_whitelist_present
      if whitelist.empty?
        @error = "Scan targets must be specified."
        return false
      end
    end

    unless @skip_host_validity_check
      unless @workspace.allow_actions_on?(whitelist.join(" "))
        @error = "Scan Targets must be inside workspace boundaries"
        return false
      end
    end

    return true
  end


  def config_to_hash
    if not @use_pass_the_hash_creds
      @pthcred = ''
    end
    conf = {
      'DS_WHITELIST_HOSTS'  => whitelist.join(" "),
      'DS_BLACKLIST_HOSTS'  => blacklist.join(" "),
      'workspace'           => workspace.name,
      'username'            => username,
      'DS_NEXPOSE_HOST'     => @nexpose_host,
      'DS_NEXPOSE_PORT'     => @nexpose_port,
      'DS_NEXPOSE_USER'     => @nexpose_user,
      'DS_NEXPOSE_CID'      => @nexpose_cid,
      'DS_SCAN_TEMPLATE'    => scan_template,
      'nexpose_pass'        => @nexpose_pass,
      'nexpose_credentials' => nexpose_credentials,
      'pthcred'              => @pthcred,
      'DS_NEXPOSE_PURGE_SITE' => nexpose_purge_site
    }

    conf['DS_AUTOTAG_OS']   = autotag_os
    conf['DS_AUTOTAG_TAGS'] = autotag_tags
    conf
  end

  def rpc_call
    client.start_nexpose(config_to_hash)
  end

  def allows_replay?
    true
  end

end

