class DownloadTask < TaskConfig

	attr_accessor :sessions, :path

	def initialize(attributes)
		super(attributes)

		@sessions = attributes[:sessions] || []
		@path     = attributes[:path]     || ''
	end

	def rpc_call
		client.start_download(
			'workspace'           => workspace.name,
			'username'            => username,
			'DS_SESSIONS'         => sessions.map{|x| x.to_s }.join(" "),
			'DS_PATH'             => path
		)
	end

end

