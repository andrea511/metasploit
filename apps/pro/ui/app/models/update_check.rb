class UpdateCheck

	attr :current_version
	attr :version
	attr :result
	attr :info
	attr :error
	attr :metrics

	def initialize(params = {})
		@proxy_params = params
		c = Pro::Client.get
		r = c.call("pro.update_available", @proxy_params)
		if (r["status"] == "success")
			@current_version = r['current']
			@version = r['version']
			@info    = r['info']
			@result  = r['result']
			@metrics = r['metrics']
		else
			@error = r["reason"]
			@error = nil if @error == ""
		end
	end

	def up_to_date?
		current_version.to_s == "dev" or result == "current"
  end

  def latest_version
    version.to_s
  end

	def apply
		c = Pro::Client.get
		r = c.call("pro.update_install", @proxy_params.merge({"version" => version}))
		if (r["result"] == "failed")
			@error = r["reason"]
			return false
		else
			@error = nil
			return true
		end
	end

end

