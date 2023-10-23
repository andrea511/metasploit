class UploadTask < TaskConfig

  attr_accessor :sessions, :path, :source, :execute

  def initialize(attributes)
    super(attributes)

    @sessions = attributes[:sessions] || []
    @path     = attributes[:path]     || ''
    @source   = attributes[:source]   || ''
    @execute  = set_default_boolean(attributes[:execute], false)
  end

  def rpc_call
    client.start_upload(
      'workspace'           => workspace.name,
      'username'            => username,
      'DS_SESSIONS'         => sessions.map{|x| x.to_s }.join(" "),
      'DS_PATH'             => path,
      'DS_SOURCE'           => source,
      'DS_EXECUTE'          => execute
    )
  end

end

