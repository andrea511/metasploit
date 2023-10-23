class LootsController < ApplicationController
	include AnalysisSearchMethods
	before_action :load_workspace, :only => [:index, :destroy_multiple]
	before_action :fix_datatables_search_parameters, :only => [:index]

	helper HostsHelper
	include TableResponder

	has_scope :workspace_id, only: [:index, :destroy_multiple]

	def add_loot
		error_msg = nil
		if params[:loot][:data].blank?
			error_msg = "No File Provided"
		elsif params[:loot][:name].blank?
			error_msg = flash[:error] = "No Name Provided"
		elsif params[:id].blank?
			error_msg = "No Host Selected"
		else
			file_contents = params[:loot][:data].tempfile.read
			loot_params = {
				data: file_contents,
				host_id: params[:id],
				ltype: "user.added.loot",
				name: params[:loot][:name],
				content_type: params[:loot][:content_type]
			}
			loot_params[:info] = params[:loot][:info] if params[:loot][:info]
			mycli = Pro::Client.get
			mycli.loot_create(loot_params)
		end

		if params[:feature_flag].blank?
			if error_msg.present?
				flash[:error] = error_msg
				redirect_to :action => "new"
			else
				redirect_to :controller => 'hosts', :action => "show"
			end
		else
			if error_msg.present?
				render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => false, :error => error_msg } }
			else
				render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => true } }
			end
		end
	end

	# TODO: Action should be called 'download'.
	def get
		@loot = Mdm::Loot.find(params[:id])
		@host = @loot.host

		ext   = "dat"
		dis   = "attachment"

		case @loot.content_type
		when /x-ms-bmp/
			ext = "bmp"
			dis = "inline"
		when /jpg|jpeg/
			ext = "jpg"
			dis = "inline"
		when /png/
			ext = "png"
			dis = "inline"
		when "text/plain"
			ext = "txt"
			dis = "inline"
		end

		fname = downloadable_fname(ext)
		File.open(@loot.path, 'rb') do |file|
			send_data file.read,
			:type => @loot.content_type,
			:disposition => (params[:disposition] || dis),
			:filename => fname
		end
	end

	# It would be nice to have ext and dis be proper attributes of Loot.
	def downloadable_fname(ext)
		if @loot.name
			@host ? "#{@host.address}_#{@loot.name}" : @loot.name
		else
			fname = "#{@loot.ltype}.#{ext}"
			@host ? "#{@host.address}_#{fname}" : fname
		end
	end

	def index
		session[:return_to] = workspace_loots_path(@workspace)

		respond_to do |format|
			format.html
			format.any(:json, :csv) do
				respond_with_table(
						Mdm::Loot,
						include: [:host],
						includes: [:host],
						presenter_class: Mdm::LootIndexPresenter,
						selections: (params[:selections] || {}).merge(ignore_if_no_selections: true)
				)
      end
    end
	end

  def destroy_multiple
    begin
      load_filtered_records(Mdm::Loot, params).readonly(false).destroy_all

      render json: { success: true }
    rescue
      render json: { success: false }
    end
  end

	def destroy
		@loot = load_loot
		respond_to do |format|
			format.json do
				if @loot.destroy
					render :json => { :success => true }
				else
					render :json => { :success => false, :errors => @loot.errors.full_messages }
				end
			end
		end
	end

	private

	def load_loots
		if params[:iDisplayLength] == '-1'
			@loots_per_page = nil
		else
			@loots_per_page = ( params[:iDisplayLength] || 20 ).to_i
		end
		@loots_offset = ( params[:iDisplayStart] || 0 ).to_i
		loots_set = pro_search(:loots,false)
		@loots = loots_set.
					limit(@loots_per_page).
					offset(@loots_offset).
					order(loots_sort_option)

		@loots_total_display_count = loots_set.length
	end

	def load_loot
		Mdm::Loot.find(params[:id])
	end

	# Generate a SQL sort by option based on the incoming DataTables parameter.
	#
	# Returns the SQL String
	def loots_sort_option
		column = case params[:iSortCol_0]
		when '2'
			'ltype'
		when '3'
			'name'
		when '4'
			'size'
		when '5'
			'info'
		end
		column + ' ' + (params[:sSortDir_0] =~ /^A/i ? 'asc' : 'desc') if column
	end



end

