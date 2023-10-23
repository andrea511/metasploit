module Mdm::Event::Decorator
	# returns the username or nil (for system events)
	def find_username
		if self.username.to_s.strip.blank? and
		   info and info[:datastore] and
		   info[:datastore]['PROUSER']
			return info[:datastore]['PROUSER']
		end
		return self.username
  end

	# returns a short one-line summary of the event
	def summary
		return "" if not info
		case name
		when "module_run", "module_complete", "module_error"
			info[:module_name]
		when "ui_command"
			info[:command]
		when "user_login"
			(info[:success] ? "successful" : "failed") + " remote login from " + info[:address]
		when "user_logoff"
			"remote logoff from " + info[:address]
		else
			""
		end
	end

	# returns a syslog-style timestamp (e.g. 'Mar 12 16:44:01')
	def timestamp
		created_at.strftime("%b %d %T") rescue Time.now.strftime("%b %d %T")
  end
end

