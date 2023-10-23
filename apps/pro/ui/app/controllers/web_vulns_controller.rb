class WebVulnsController < ApplicationController
  include AnalysisSearchMethods
  before_action :find_web_vuln, :only => [:show, :related_hosts]
  before_action :find_host, :only => [:show]
  before_action :find_workspace, :only => [:show]
  before_action :load_workspace, :only => [:index, :combined]
  before_action :application_backbone, only: [:show, :index]

  helper RefHelper
  include TableResponder
  include FilterResponder
  include VulnsHelper

  def index
    session[:return_to] = workspace_web_vulns_path(@workspace)

    respond_to do |format|
      format.html
      format.any(:json, :csv) do
        if is_table?
          json = as_table(
            Mdm::WebVuln,
            presenter_class: Mdm::WebVulnIndexPresenter,
            selections: (params[:selections] || {}).merge(ignore_if_no_selections: true)
          )

          respond_with json
        else
          web_vulns = Mdm::Workspace.find(params["workspace_id"]).web_vulns


          respond_with web_vulns
        end

      end
    end
  end

  #
  # @opts params :refsOnly [Boolean] will render only vuln references
  #
  def show
    # Signal the client that we should redirect to the show view, rather than loading index
    gon.route = 'show'
    gon.id = params[:id]

    respond_to do |format|
      format.html
      format.json do
        template = params[:refsOnly] ? :show_refs_only : :show
        render template
      end
    end
  end

  def related_hosts
    respond_to do |format|
      format.json{
        render json: as_table(related_hosts_relation,{
          presenter_class: Mdm::RelatedHostPresenter,
          search: params[:search]
        })
      }
    end
  end

  def related_hosts_filter_values
    values = filter_values_for_key(related_hosts_relation, params)
    render json: values.as_json
  end

  # TODO: For the moment, we're only searching by related hosts in the single
  # vuln view, so we don't need to mess with the base search_operators method.
  # In the future, if we want to search across vulns, we'll need to fix this,
  # because att that point search_operator_class should return Mdm::Vuln.
  def search_operator_class
    Mdm::Host
  end

  private

  def find_web_vuln
    @web_vuln = Mdm::WebVuln.find(params[:id])
  end

  def find_host
    if params[:host_id]
      @host = Mdm::Host.find(params[:host_id])
    else
      @host = @web_vuln.host
    end
  end

  def find_workspace
    @workspace = @host.workspace
  end

  # Load the Vulns with correct sorting and pagination.
  #
  # @return [void]
  # TODO: not sure this search support webvulns since framework does not directly expose them
  def load_vulns
    vuln_set = pro_search(:webvulns, false).includes(:vuln_attempts)
    paged_vuln_set = vuln_set.limit(@web_vulns_per_page).offset(@web_vulns_offset)
    @web_vulns = sort_vulns(paged_vuln_set)

    @web_vulns_total_display_count = @web_vulns_total_count
  end

  # Generate a SQL sort by option based on the incoming DataTables parameter.
  #
  # @param relation [ActiveRecord::Relation]
  # @return [ActiveRecord::Relation]
  def sort_vulns(relation)
    order_predication_class = Arel::Nodes::Descending

    if params[:sSortDir_0] =~ /^A/i
      order_predication_class = Arel::Nodes::Ascending
    end

    case params[:iSortCol_0].to_i
      when 1
        # okay, Mdm::Host has some gotchas to sorting:
        # 1. Generally, sort Hosts by #name (type:string)
        # 2. If Host#name is blank, default to sorting by #address (type:inet)
        relation = relation.order(
          order_predication_class.new(
            Arel::SqlLiteral.new(
              'CASE hosts.name WHEN HOST(hosts.address::inet)::text THEN '+
              'NULL ELSE LOWER(hosts.name) END'
            )
          )
        )

        # 3. If Host#name is EQUAL to Host#address, default to sorting by #address (type:inet)
        #       (otherwise the address will be alphabetically sorted, WRONG)
        relation = relation.order(
          order_predication_class.new(
            Mdm::Host.arel_table[:address]
          )
        )
      when 2
        relation = relation.order(
          order_predication_class.new(
            Mdm::Service.arel_table[:port]
          )
        )
      when 3
        relation = relation.order(
          order_predication_class.new(
            Mdm::WebVuln.arel_table[:name]
          )
        )
      else
        vulns = Mdm::WebVuln.arel_table
        relation = relation.order(
          order_predication_class.new(
            vulns[:exploited_at]
          ),
          order_predication_class.new(
            vulns[:vuln_attempt_count]
          ).reverse
        )
    end

    relation
  end

  # Generate a SQL sort by option based on the incoming DataTables parameter.
  #
  # Returns the SQL String
  def vulns_combined_sort_option
    column = case params[:iSortCol_0]
               when '1'
                 'name'
               when '3'
                 'host_count'
             end
    column + ' ' + (params[:sSortDir_0] =~ /^A/i ? 'asc' : 'desc') if column
  end


  def redirect_to_hosts_show
    redirect_to host_path(@web_vuln.host) + "#vulnerabilities"
  end

  def ref_data
    @web_vuln.refs.build
  end


  # Generate an include option for the tag table when loading records
  # for the Analysis tab.
  #
  # Returns the Array condition.
  def tags_include_option
    [:refs, {:host => :tags}]
  end

  # TODO: update for web_vuln
  def related_hosts_relation
    find_web_vuln
    #TODO: Optimize into one query?
    ref_ids = Mdm::VulnRef.select(:ref_id).where(vuln_id: @web_vuln.id).pluck(:ref_id)

    relation = Mdm::Host.with_table_data.related_hosts(ref_ids,@web_vuln.host)
  end

  def web_vuln_params
    params.require(:web_vuln).permit!
  end
end
