module ProjectsHelper
	# Determines if the overview section of the dashboard should be collapsed.
	#
	# Returns true if the section should be collapsed, false otherwise.
	def show_dashboard?
		@workspace.hosts.count > 0 && @workspace.services.count > 0
	end
end
