class NotesController < ApplicationController
	include AnalysisSearchMethods
	before_action :load_workspace
	before_action :set_pagination, :only => [:index, :combined]
	before_action :fix_datatables_search_parameters, :only => [:index]
  before_action :note_params, :only => [:create]
  before_action :store_controller_in_thread , :only => [:index]
  after_action  :clear_controller_from_thread, :only => [:index]


	helper HostsHelper
	include TableResponder

	has_scope :workspace_id, only: [:index, :destroy_multiple]

  def index
    session[:return_to] = workspace_notes_path(@workspace)

    respond_to do |format|
      format.html
      format.any(:json, :csv) do
        respond_with_table(
            Mdm::Note,
            include: [:host],
            includes: [:host],
            presenter_class: Mdm::NoteIndexPresenter,
            selections: (params[:selections] || {}).merge(ignore_if_no_selections: true)
        )
      end
    end
  end

  def create
    respond_to do |format|
      format.json{
        if @workspace.id == params[:note][:workspace_id] and not params[:note][:type].nil?
          klass = params[:note][:type].constantize

          noteable = klass.joins(
            klass.join_association(:notes, Arel::Nodes::OuterJoin)
          ).where(
            klass[:id].eq(params[:note][:type_id]),
            Mdm::Note[:workspace_id].eq(@workspace.id)
          ).first

          unless noteable.nil?
            if noteable.notes.size > 0
              noteable.notes[0].data = {comment:params[:data][:comment]}
              noteable.notes[0].workspace = @workspace
            else
              noteable.notes.new(data:{comment: params[:data][:comment]})
              noteable.notes[0].workspace = @workspace
            end

            if noteable.save
              render :json => {success: true}
            else
              render json: {error: noteable.notes[0].errors}, status: :bad_request
            end
          end
        else
          render json: {error: "Invalid note type"} ,status: :bad_request
        end
      }
    end
  end

  def destroy_multiple
    begin
      load_filtered_records(Mdm::Note, params).readonly(false).destroy_all

      render json: { success: true }
    rescue
      render json: { success: false }
    end
  end

	def combined
		load_combined_notes if request.format.json?

		respond_to do |format|
			format.html
			format.json { render :partial => 'notes_combined', :notes => @notes }
		end
  end

  # Return the current controller context
  def get_binding
    binding
  end

	private

	# Determine the correct pagination arguments based on the incoming DT parameters.
	#
	# Returns nothing.
	def set_pagination
		if params[:iDisplayLength] == '-1'
			@notes_per_page = nil
		else
			@notes_per_page = (params[:iDisplayLength] || 20).to_i
		end
		@notes_offset = (params[:iDisplayStart] || 0).to_i
	end

	def load_notes
		notes_set = pro_search(:notes,false)
		@notes = notes_set.
					limit(@notes_per_page).
					offset(@notes_offset).
					order(notes_sort_option)
		@notes_total_display_count = notes_set.length
	end

	def load_combined_notes
		notes_set = pro_search(:notes,true)
		combined_notes_group_option = "notes.ntype"
		@notes = notes_set.
					select("COUNT(notes.id) AS host_count, notes.ntype").
					group(combined_notes_group_option).
					limit(@notes_per_page).
					offset(@notes_offset).
					order(notes_combined_sort_option)
		@notes_total_display_count = notes_set.length
	end

	# Generate a SQL sort by option based on the incoming DataTables parameter.
	#
	# Returns the SQL String
	def notes_sort_option
		column = case params[:iSortCol_0]
		when '2'
			'ntype'
		when '4'
			'created_at'
		end
		column + ' ' + (params[:sSortDir_0] =~ /^A/i ? 'asc' : 'desc') if column
	end

	# Generate a SQL sort by option based on the incoming DataTables parameter.
	#
	# Returns the SQL String
	def notes_combined_sort_option
		column = case params[:iSortCol_0]
		when '0'
			'ntype'
		when '1'
			'host_count'
		end
		column + ' ' + (params[:sSortDir_0] =~ /^A/i ? 'asc' : 'desc') if column
  end

  #  Filter out note types that are not in the whitelist
  def note_params
    unless [Mdm::Vuln.name,Mdm::Service.name,Mdm::Host.name].include? params[:note][:type]
      params[:note][:type] = nil
    end
  end

  # So we can store current controller
  def store_controller_in_thread
    Thread.current[:controller] = self
  end

  # Clear the current controller after the request
  def clear_controller_from_thread
    Thread.current[:controller] = nil
  end

end
