class ModuleRunTask < TaskConfig
  include Metasploit::Pro::AttrAccessor::Boolean

  attr :module
  attr :run_id
  attr :options
  attr :newly_set_options # Unset, non-boolean options with defaults that we will use
  attr :action
  attr :target
  attr :sessions

  attr :whitelist, :blacklist, :timeout
  attr :connection, :payload_type, :payload_ports, :payload_lhost, :macro_name

  boolean_attr_accessor :stage_encoding, :default => false


  CONNECTIONS = ["auto", "reverse", "bind"].map{|x| x.capitalize }
  PAYLOAD_TYPES = ["meterpreter", "meterpreter 64-bit", "command shell", "powershell"].map{|x| x.capitalize }

  def set_module_options(opts={}, explicit_falses: false)
    @module.options.each { |o| @default_options[o.name] = o.default}
    @options = {}
    @newly_set_options = []
    opts ||= {}
    if opts.empty?
      # This is when the module is first rendered, just present all the defaults
      @options = @default_options
    else
      # This is when the user actually submits with some options.
      modopts = @module.options.map {|o| o.name}
      useropts = opts.keys
      unsetopts = modopts - useropts
      @module.options.each do |o|
        if unsetopts.include?(o.name) and o.type == "bool" and !explicit_falses
          # First, deal with boolean falses, which are false because they're
          # missing. This is due to HTML forms not submitting any data for
          # unchecked checkboxes.
          @options[o.name] = false
        elsif unsetopts.include?(o.name)
          # Set other unset options to the default, which could be `nil`, but
          # since it was unset it would be set to `nil` anyway. Also sets
          # boolean defaults to the default when re-running a session.
          @options[o.name] = o.default
          @newly_set_options << o.name unless o.default.nil?
        elsif opts[o.name] == ""
          # Now deal with options that had defaults, but were set to blank.
          if @default_options[o.name].to_s != ""
            @options[o.name] = :blank # Had a default value but now it's blank
          end
        elsif opts[o.name] == "false" and o.type == "bool"
          # If the user is re-running a session, they came in with a slew of options
          # of "true" and "false" Set those to their boolean values.
          @options[o.name] = false
        elsif opts[o.name] == "true" and o.type == "bool"
          @options[o.name] = true
        else
          # Finally, deal with all other options
          @options[o.name] = opts[o.name]
        end
      end
    end
    return @options
  end

  def initialize(attrs)
    super(attrs)
    @default_options = {}
    @run_id = attrs[:run_id]
    @module = attrs[:module]
    set_module_options(attrs[:options], explicit_falses: attrs[:explicit_falses])

    # @sessions need to be session.local_ids, aka framework session.sid
    @sessions = attrs[:sessions] || []

    @whitelist = attrs[:whitelist] || []
    @blacklist = attrs[:blacklist] || []
    @timeout = attrs[:timeout] || 5
    @action = attrs[:action]
    @target = attrs[:target] || @module.default_target

    @connection = attrs[:connection] || "Auto"
    @payload_type = attrs[:payload_type] || "Meterpreter"
    @payload_ports = attrs[:payload_ports] || "1024-65535"
    @payload_lhost = attrs[:payload_lhost]
    @payload_lhost = nil if @payload_lhost.to_s.strip.empty?
    @macro_name = attrs[:macro_name] || ''

    @whitelist = tags_and_addresses(@whitelist)
    @blacklist = tags_and_addresses(@blacklist)

    if attrs[:whitelist_string]
      @whitelist = tags_and_addresses(attrs[:whitelist_string].split(/\s+/))
      @whitelist = @whitelist.map{|x| x unless x.empty?}.compact
    end
    if attrs[:blacklist_string]
      @blacklist = tags_and_addresses(attrs[:blacklist_string].split(/\s+/))
      @blacklist = @blacklist.map{|x| x unless x.empty?}.compact
    end

    @run_on_all_sessions = set_default_boolean(attrs[:run_on_all_sessions], false)
  end

  def whitelist_string
    whitelist.join("\n")
  end

  def blacklist_string
    blacklist.join("\n")
  end

  def config_to_hash
    # Purge poisonous nils and blanks
    @options.delete_if { |k,v| v.nil? || v == "" }

    # Convert :blank directives to actual blanks. Modules have
    # to be able to handle the cases where a default value was
    # set, but the user set it to "" (since we can't pass nils
    # in RPC).
    @options.each { |k,v| @options[k] = "" if v == :blank}

    # Set some common default options
    @options["ExitOnSession"] = "false"

    ret = client.module_validate(
      @module.fullname,
      @options.merge({
        'SESSION' => (@sessions.empty? ? "" : @sessions.first),
        'RHOST' => '50.50.50.50',
        'RHOSTS' => '50.50.50.50',
        'TARGET' => target.to_s,
        'ACTION' => action.to_s,
      })
    )
    if not (ret and ret['result'] == 'success')
      @error = ret['error']
      return ret
    end

    ds = {}
    @options.each_pair {|k,v| ds["DS_#{k}"] = v }

    unless @sessions.empty?
      ds["DS_SESSIONS"] = ''

      unless @run_on_all_sessions
        ds["DS_SESSIONS"] = @sessions.join(" ")
      end

      ds.delete("DS_SESSION")
    end

    ds.merge!({
      'DS_RUN_ID'                 => run_id,
      'DS_MODULE'                 => @module.fullname,
      'DS_WHITELIST_HOSTS'        => whitelist_string,
      'DS_BLACKLIST_HOSTS'        => blacklist_string,
      'DS_EXPLOIT_TIMEOUT'        => timeout.to_i,
      'DS_ACTION'                 => action.to_s,
      'DS_TARGET'                 => target.to_s,
      'workspace'                 => workspace.name,
      'username'                  => username,
      'DS_PAYLOAD_METHOD'         => connection.downcase,
      'DS_PAYLOAD_TYPE'           => payload_type.downcase,
      'DS_PAYLOAD_PORTS'          => payload_ports,
      'DS_EnableStageEncoding'    => stage_encoding?
    })

    if current_profile.settings['payload_prefer_https']
      ds['DS_EnableReverseHTTPS'] = true
    end

    if current_profile.settings['payload_prefer_http']
      ds['DS_EnableReverseHTTP'] = true
    end

    if not macro_name.to_s.empty?
      ds['DS_AutoRunScript'] = "post/pro/multi/macro MACRO_NAME='#{macro_name}'"
    end

    ds['DS_PAYLOAD_LHOST'] = payload_lhost if payload_lhost
    ds
  end

  def rpc_call
    ds = config_to_hash
    if ds['result'].to_s == 'failure'
      @error = ds['error'].to_s
      return nil
    end
    client.start_single(ds)
  end

  # Validates ModuleRunTask Pro Side, as well as RPC Module Validations
  def rpc_valid?
    pro_validation = valid?
    ds = config_to_hash
    if ds['result'].to_s == 'failure'
      @error = ds['error'].to_s
      false
    else
      pro_validation
    end
  end

  def valid?
    # Validate address space -- note client modules don't require
    # a whitelist

    whitelist.each do |ip|
      next if valid_ip_or_range?(ip)
      @error = "Invalid target IP address: #{ip}"
      return false
    end

    if (@sessions.present? && !sessions_valid?) ||
        (whitelist.present? && !@workspace.allow_actions_on?(whitelist.join(" ")))
      @error = "Target Addresses must be inside workspace boundaries"
      return false
    end

    blacklist.each do |ip|
      next if valid_ip_or_range?(ip)
      @error = "Invalid excluded IP address: #{ip}"
      return false
    end

    # Validate timeout
    if timeout
      if timeout.to_f <= 0
        @error = "Invalid timeout value: #{timeout}"
        return false
      end
    end

    # Validate payload type
    if payload_type and !PAYLOAD_TYPES.include? payload_type
      @error = "Invalid payload type: #{payload_type}"
      return false
    end

    # Validate payload connection
    if connection and !CONNECTIONS.include? connection
      @error = "Invalid Connection Type: #{connection}"
      return false
    end

    # Validate payload listener ports
    r = Rex::Socket.portspec_crack(payload_ports) rescue []
    if r.length == 0
      @error = "Invalid Payload Ports: #{payload_ports}"
      return false
    end

    # Validate payload listener host override
    if payload_lhost and not valid_ip_or_range?(payload_lhost)
      @error = "Invalid Payload Mdm::Listener Address: #{payload_lhost}"
      return false
    end

    if not macro_name.strip.to_s.empty?
      if not ::Mdm::Macro.find_by_name(macro_name)
        @error = "Invalid Mdm::Macro Name"
        return false
      end
    end

    @error = nil
    return true
  end
end
