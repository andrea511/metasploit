module Mdm::Note::Decorator
	# Returns true if the Mdm::Note is marked as critical and has not been seen,
	# false otherwise.
	def flagged?
		self.critical? && !self.seen?
  end

	# returns a syslog-style timestamp (e.g. 'Mar 12 16:44:01')
	def timestamp
		updated_at.strftime("%b %d %T")
	end
end

