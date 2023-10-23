class ServicesController < ApplicationController
	include AnalysisSearchMethods
	before_action :load_workspace
	before_action :set_pagination, :only => [:index, :combined]
	before_action :fix_datatables_search_parameters, :only => [:index]

	helper HostsHelper
	include TableResponder

  has_scope :workspace_id, only: [:index, :destroy_multiple, :quick_multi_tag]

	def index
		session[:return_to] = workspace_services_path(@workspace)

    respond_to do |format|
      format.html
      format.any(:json, :csv) do
        respond_with_table(
            Mdm::Service,
            include: [:host],
            includes: [:host],
            presenter_class: Mdm::ServiceIndexPresenter,
            selections: (params[:selections] || {}).merge(ignore_if_no_selections: true)
        )
      end
    end
	end

	def combined
		load_combined_services if request.format.json?
    load_combined_services(false) if request.format.js?

		respond_to do |format|
			format.html
			format.json { render :partial => 'services_combined', :services => @services}
      #Huh? the above does not return JSON
      #TODO Fix partial usage of aggregate services
      format.js {render :json =>@services}
		end
	end

	def destroy_multiple
    begin
      load_filtered_records(Mdm::Service, params).readonly(false).destroy_all

      render json: { success: true }
    rescue
      render json: { success: false }
    end
	end

	# Tag the associated hosts of services selected
	#
	# Return json of tags
	def quick_multi_tag
		selected_services = load_filtered_records(Mdm::Service, params)
		host_ids = selected_services.map{|service|service.host.id}
		host_params = params
		host_params['entity_ids'] = host_ids
		host_params['selections'] = {
				"select_all_state"=>"",
				"selected_ids"=> host_ids
		}
		selected_hosts = load_filtered_records(Mdm::Host, host_params)

		render json: TagCreator.build(
							 host_params, Mdm::Host, relation: selected_hosts)
	end

	private

	# Determine the correct pagination arguments based on the incoming DT parameters.
	#
	# Returns nothing.
	def set_pagination
		if params[:iDisplayLength] == '-1'
			@services_per_page = nil
		else
			@services_per_page = (params[:iDisplayLength] || 20).to_i
		end
		@services_offset = (params[:iDisplayStart] || 0).to_i
	end

	def load_services
		service_set = pro_search(:services,false)
		@services = service_set
					.limit(@services_per_page)
					.offset(@services_offset)
					.reorder(services_sort_option)
					.group('services.id, hosts.id')
					.select('hosts.name AS host_name, hosts.address, hosts.id AS host_id, ' +
						# okay, Mdm::Host has some gotchas to sorting:
						# 1. Generally, sort Hosts by #name (type:string)
						# 2. If Host#name is blank, default to sorting by #address (type:inet)
						# 3. If Host#name is EQUAL to Host#address, default to sorting by #address (type:inet)
						#       (otherwise the address will be alphabetically sorted, WRONG)
						'(CASE hosts.name WHEN HOST(hosts.address::inet)::text THEN NULL ELSE LOWER(hosts.name) END) ' +
						'AS host_name_sort')
						# HOST(hosts.address)::text returns e.g. '127.0.0.1', whereas
						#   CAST(hosts.address TO text) returns e.g. '127.0.0.1/32'

		@services_total_display_count = service_set.length
	end

	def load_combined_services(group=true)
		service_set = pro_search(:services, group)
		@services = service_set.
					limit(@services_per_page).
					offset(@services_offset).
					order(services_combined_sort_option)
        @services_total_display_count = service_set.length
	end

	# Generate a SQL sort by option based on the incoming DataTables parameter.
	#
	# Returns the SQL String
	def services_sort_option
		sort_dir = params[:sSortDir_0] =~ /^A/i ? 'asc' : 'desc'
		case params[:iSortCol_0]
		when '1'
			"host_name_sort #{sort_dir}, hosts.address #{sort_dir}"
		when '2'
			"services.name #{sort_dir}"
		when '3'
			"services.proto #{sort_dir}"
		when '4'
			"services.port #{sort_dir}"
		when '5'
			"services.info #{sort_dir}"
		when '6'
			"services.state #{sort_dir}"
		else
			"services.updated_at #{sort_dir}"
		end
	end


	# Generate a SQL sort by option based on the incoming DataTables parameter.
	#
	# Returns the SQL String
	def services_combined_sort_option
		column = case params[:iSortCol_0]
		when '0'
			'services.name'
		when '1'
			'services.proto'
		when '2'
			'services.port'
		when '3'
			'services.info'
		when '4'
			'host_count'
		end
		column + ' ' + (params[:sSortDir_0] =~ /^A/i ? 'asc' : 'desc') if column
	end

end
