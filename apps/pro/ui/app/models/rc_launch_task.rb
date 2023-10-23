class RcLaunchTask < TaskConfig

  #@return [String] A series of datastore options in the format of OPT="VALUE" OPT2="Value2"
  attr_accessor :datastore_opts
  #@return [String] The path to the RC Script to launch
  attr_accessor :rc_path

  def initialize(attrs)
    super(attrs)

    @datastore_opts = attrs[:datastore_opts] || ""
    @rc_path        = attrs[:rc_path]
  end

  # Returns a hash representing all of the configuration options
  #
  # @return [Hash] The options hash for the TransportChange RPC call
  def config_to_hash
    conf = {
      'DS_RC_PATH'      => rc_path,
      'DS_RC_DATASTORE' => datastore_opts,
      'workspace'       => workspace.name,
      'username'        => username
    }
    conf.reject{ |key,value| value.blank? }
  end

  # Responsible for making the actual RPC call.
  # It passes in the session_id and the output from #config_to_hash
  # @return [Boolean] Whether the task was successful
  def rpc_call
    if valid?
      client.start_rc_launch(config_to_hash)
    end
  end


  def valid?
    return false unless rc_path
    return false unless File.exist?(rc_path)
    true
  end


end
