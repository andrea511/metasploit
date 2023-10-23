class EventsController < ApplicationController
	before_action :load_workspace

	before_action :require_admin, :only => [:delete_all]
	
	def index
		@page = (params[:page] || 1).to_i
		@page = 1 if @page < 1
		@rows_per_page = (params[:n] || 50).to_i
		@offset = (@page-1) * @rows_per_page
		@event_count = @workspace.events.size

		@num_pages = 1 + ((@event_count-1) / @rows_per_page)

		# TODO: use or eliminate
		@events = @workspace.recent_events(@rows_per_page).offset(@offset)

		# clear flagged events once they've been viewed
		@workspace.events.flagged.each { |e| e.seen = true; e.save! }
	end

	def delete_all
		n = @workspace.events.size
		@workspace.events.clear
		flash[:notice] = "#{n} events deleted"	
		redirect_to workspace_events_path
	end

end
