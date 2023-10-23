class UpdateStatus

	attr_accessor :error, :download_pcnt, :result

	def self.get
		begin
			c = Pro::Client.get
			status = c.call("pro.update_status", {})
			result = status["result"]
			error  = status["error"]
			error  = nil if error == ""

			download_pcnt = status["download_pcnt"] || 0

			UpdateStatus.new(result, error, download_pcnt)
		rescue Rex::ConnectionRefused => e
			UpdateStatus.new("restarting", nil, nil)
		end
	end

	def initialize(result, error, download_pcnt)
		@result = result
		@error = error
		@download_pcnt = download_pcnt
	end

	def in_progress?
		downloading? or installing? or complete? or restarting?
	end

	def downloading?
		@result == "downloading" or @result == "starting" or @result == "querying"
	end

	def installing?
		@result == "installing"
	end

	def complete?
		@result == "complete"
	end

	def restarting?
		@result == "restarting"
	end

	def error?
		@result == "error"
	end

	def restart
		c = Pro::Client.get
		r = c.call("pro.restart_service", {})
		success = (r["status"] == "success")
		@result = "restarting" if success
		return success
	end

end
