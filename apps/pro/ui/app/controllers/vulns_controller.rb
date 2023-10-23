class VulnsController < ApplicationController
  include AnalysisSearchMethods
  before_action :find_vuln, :only => [
                            :edit, :destroy, :update, :show,
                            :details, :attempts, :exploits,
                            :history, :related_modules, :related_hosts,
                            :update_last_vuln_attempt_status,:restore_last_vuln_attempt_status
                          ]
  before_action :find_host, :only => [:new, :edit, :create, :show, :details, :attempts, :exploits ]
  before_action :find_workspace, :only => [:new, :edit, :show, :details, :attempts, :exploits ]
  before_action :load_workspace, :only => [:index, :combined, :destroy_multiple, :destroy_multiple_groups]
  before_action :application_backbone, only: [:show, :index]

  helper RefHelper
  include TableResponder
  include FilterResponder
  include VulnsHelper

  has_scope :workspace_id, only: [:index, :destroy_multiple, :push_to_nexpose_status, :push_to_nexpose_message]

  def index
    session[:return_to] = workspace_vulns_path(@workspace)

    respond_to do |format|
      format.html
      format.any(:json, :csv) do
        if is_table?
          json = as_table(
            Mdm::Vuln,
            include: [:host, :service],
            includes: [:host, :service, :vuln_attempts, :refs],
            presenter_class: Mdm::VulnIndexPresenter,
            selections: (params[:selections] || {}).merge(ignore_if_no_selections: true)
          )

          # TODO: Yes, this is terrible. We'll have to address it in IA.
          json[:collection].each do |vuln_json|
            vuln = Mdm::Vuln.find(vuln_json['id'].to_i)
            vuln_json['status_html'] = vuln_status_html(vuln, params, escape: false)
          end

          respond_with json
        else
          vulns = Mdm::Vuln.joins(:host).where("hosts.workspace_id"=>params["workspace_id"])


          respond_with vulns
        end

      end
    end
  end

  def new
    @vuln = @host.vulns.new
    ref_data
    render layout: !request.xhr?
  end

  def edit
    ref_data
    render layout: !request.xhr?
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

  def details
    ref_data
    exploit_module_match_data
    respond_to do |format|
      format.html { render :partial => "vuln_details_tab" }
      format.js { render :partial => "vuln_details_tab"}
    end
  end

  def detail
    respond_to do |format|
      format.json do

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

  def related_modules
    respond_to do |format|
      format.json{
        relation = Mdm::Module::Detail.with_table_data.distinct.related_modules(@vuln)
        render json: as_table(relation,{presenter_class: Mdm::ModuleDetailPresenter, vuln: @vuln})
      }
    end
  end

  def update_last_vuln_attempt_status
    respond_to do |format|
      format.json{
        vuln_attempt = @vuln.vuln_attempts.last
        vuln_attempt.last_fail_reason = vuln_attempt.fail_reason
        vuln_attempt.fail_reason =  Mdm::VulnAttempt::Status::NOT_EXPLOITABLE
        vuln_attempt.save
        render template: 'vulns/show'
      }
    end
  end

  def restore_last_vuln_attempt_status
    respond_to do |format|
      format.json{
        vuln_attempt = Mdm::VulnAttempt.where(vuln_id:@vuln.id).where('vuln_attempts.last_fail_reason IS NOT NULL').first
        vuln_attempt.fail_reason = vuln_attempt.last_fail_reason
        vuln_attempt.last_fail_reason = nil
        vuln_attempt.save
        render template: 'vulns/show'
      }
    end
  end


  def history
    respond_to do |format|
      format.json{
        relation = Mdm::Vuln.with_table_data.event_history(@vuln)
        render json: as_table(relation, presenter_class: Mdm::VulnPresenter)
      }
    end
  end

  def attempts
    ref_data
    exploit_module_match_data
    respond_to do |format|
      format.html { render :partial => "vuln_attempts_tab" }
      format.js { render :partial => "vuln_attempts_tab" }
    end
  end

  def exploits
    ref_data
    exploit_module_match_data
    respond_to do |format|
      format.html { render :partial => "vuln_exploits_tab" }
      format.js { render :partial => "vuln_exploits_tab" }
    end
  end

  def create
    @vuln = @host.vulns.new(vuln_params)

    respond_to do |format|
      format.html{
        if @vuln.save
          flash[:notice] = "Vulnerability added"
          redirect_to_hosts_show
        else
          ref_data
          find_host
          find_workspace
          render :action => 'new'
        end
      }
      format.json{
        if @vuln.save
          render json: {success: :ok}
        else
          render json: {success: false, error: @vuln.errors}, status: :error
        end
      }
    end
  end

  def update
    respond_to do |format|
      vuln_params[:existing_ref_attributes] ||= {}
      format.html {
        if @vuln.update(vuln_params)
          flash[:notice] = "Vulnerability added"
          redirect_to_hosts_show
        else
          ref_data
          find_host
          find_workspace
          render :action => 'edit'
        end
      }
      format.json {
        @vuln.assign_attributes(vuln_params)

        if @vuln.save
          render :json => {success: :ok}
        else
          render :json => {success: false, :error => @vuln.errors}, :status => :bad_request
        end
      }
    end
  end

  def destroy
    @vuln.destroy

    respond_to do |format|
      format.html do
        flash[:notice] = "Vulnerability removed"
        redirect_to_hosts_show
      end
      format.js
      format.json{
        render :json => {sucess: :ok}
      }
    end
  end

  def destroy_multiple
    # TODO: This is (almost) identical to the cores_controller implementation.
    # Does it belong it TableResponder? New module?
    begin
      load_filtered_records(Mdm::Vuln, params).readonly(false).destroy_all

      render json: { success: true }
    rescue
      render json: { success: false }
    end
  end

  def destroy_multiple_groups
    vulns = Mdm::Vuln.where('id IN (?)', params[:vuln_ids]).map do |vuln|
      origin_vuln = Mdm::Vuln.find(vuln.id)
      group = Mdm::Vuln.where('vulns.name = ?', origin_vuln.name)
                       .joins(:host).where('hosts.workspace_id = ?', @workspace.id)
      group.readonly(false).destroy_all
    end

    if vulns.flatten.length.zero?
      flash[:error] = "No vulnerabilities selected to delete"
    else
      flash[:notice] = view_context.pluralize(vulns.flatten.length, "vuln") + " deleted"
    end

    render_js_redirect(combined_workspace_vulns_path(@workspace))
  end

  # TODO: For the moment, we're only searching by related hosts in the single
  # vuln view, so we don't need to mess with the base search_operators method.
  # In the future, if we want to search across vulns, we'll need to fix this,
  # because att that point search_operator_class should return Mdm::Vuln.
  def search_operator_class
    Mdm::Host
  end

  #
  # Renders json boolean response of the status of 'Push To Nexpose' Button In Vulns Index View
  #
  # @required controller params provides table selections, ex:
  #   params = {
  #     "selections" => {
  #       "select_all_state" => "",
  #       "selected_ids" = > ["123"]
  #     }
  #   }
  #
  # @see TableResponder#selected_records
  #
  # @return [JSON] Nexpose button status
  #
  # @example
  #   POST to /workspaces/1/vulns/push_to_nexpose_status
  #   #=> { status: true }
  #
  def push_to_nexpose_status
    raise ArgumentError unless params[:selections]

    message = i18n_nexpose_messages[:button]

    selected_vuln_ids = load_filtered_records(Mdm::Vuln, params).pluck(:id)

    if Mdm::NexposeConsole.any?
      # Don't load vuln objects, just need ids
      from_nexpose_count = Mdm::Vuln.from_nexpose(selected_vuln_ids).count
      results = MetasploitDataModels::AutomaticExploitation::MatchResult.for_vuln_id(selected_vuln_ids)
      exception_count = Mdm::Vuln.from_nexpose(selected_vuln_ids).joins(:vuln_attempts).
        where(Mdm::VulnAttempt[:fail_reason].
                eq(Mdm::VulnAttempt::Status::NOT_EXPLOITABLE)).count

      validation_count = results.succeeded.count

      status = from_nexpose_count > 0 &&
               ( validation_count > 0 ||
                   exception_count > 0 )

      reason = if from_nexpose_count == 0
                 if selected_vuln_ids.empty?
                  message[:none_selected]
                 else
                  message[:not_from_nexpose]
                 end
      elsif from_nexpose_count > 0 &&
            ( validation_count == 0 &&
                exception_count == 0 )
        message[:from_nexpose_not_pushable]
      else
        message[:from_nexpose_pushable]
      end
    else
      reason = message[:no_console_exists]
      status = selected_vuln_ids.count > 0
    end

    render json: {status: status, reason: reason}
  end

  def push_to_nexpose_message

    message = i18n_nexpose_messages[:push_modal]

    return_status = {
        :has_console     => false,
        :has_console_enabled => false,
        :has_validations => false,
        :has_exceptions  => false,
        :message         => "",
        :title           => message[:title][:has_console]
    }

    if !params[:vv_run]
      selected_vuln_ids = load_filtered_records(Mdm::Vuln, params).pluck(:id)
    else
      selected_vuln_ids = load_filtered_records(Mdm::Vuln, :workspace_id=> params[:workspace_id]).where.not(:vuln_attempt_count => 0).pluck(:id)
    end

    if Mdm::NexposeConsole.for_vuln_id(selected_vuln_ids).where(enabled: true).present?
      return_status[:has_console] = true
      return_status[:has_console_enabled] = true
      results = MetasploitDataModels::AutomaticExploitation::MatchResult.for_vuln_id(selected_vuln_ids)
      if params[:vv_run]
        results.failed.each do |result|
          service = Mdm::Vuln.where(id:result.match.matchable_id).first.service
          port = service.port
          proto = service.proto
          Mdm::VulnAttempt.create(vuln_id: result.match.matchable_id, attempted_at: result.created_at, exploited: false, fail_reason: Mdm::VulnAttempt::Status::NOT_EXPLOITABLE, last_fail_reason: Mdm::VulnAttempt::Status::NOT_EXPLOITABLE, module: result.match.module_fullname, fail_detail: "No session created")
          Mdm::ExploitAttempt.create(vuln_id: result.match.matchable_id, host_id:Mdm::Vuln.where(id:result.match.matchable_id).first.host, service_id: service.id, attempted_at: result.created_at, exploited: false, port:port, proto:proto, fail_reason: Mdm::VulnAttempt::Status::NOT_EXPLOITABLE, module: result.match.module_fullname, fail_detail: "No session created")
        end
      end
      exception_vulns =  Mdm::Vuln.from_nexpose(selected_vuln_ids).joins(:vuln_attempts).
        where(Mdm::VulnAttempt[:fail_reason].
                eq(Mdm::VulnAttempt::Status::NOT_EXPLOITABLE)).count

      validated_vulns = results.succeeded.count
      if validated_vulns > 0 and exception_vulns > 0
        return_status[:has_validations] = true
        return_status[:has_exceptions] = true
        return_status[:message] = message[:has_validations_and_exceptions]
      elsif validated_vulns > 0 && exception_vulns == 0
        return_status[:has_validations] = true
        return_status[:message] = message[:has_only_validations]
      elsif validated_vulns == 0 && exception_vulns > 0
        return_status[:has_exceptions] = true
        return_status[:message] = message[:has_only_exceptions]
      else
        return_status[:message] = message[:has_no_results]
      end
    elsif Mdm::NexposeConsole.any?
      return_status[:has_console] = true
      return_status[:message] = message[:no_console_enabled]
      return_status[:title] = message[:title][:no_console_enabled]
    else
      return_status[:message] = message[:no_console_exists]
      return_status[:title] = message[:title][:no_console_exists]
    end
    render json: return_status
  end

  private

  def find_vuln
    @vuln = Mdm::Vuln.find(params[:id])
  end

  def find_host
    if params[:host_id]
      @host = Mdm::Host.find(params[:host_id])
    else
      @host = @vuln.host
    end
  end

  def find_workspace
    @workspace = @host.workspace
  end

  # Load the Vulns with correct sorting and pagination.
  #
  # @return [void]
  def load_vulns
    vuln_set = pro_search(:vulns, false).includes(:vuln_attempts)
    paged_vuln_set = vuln_set.limit(@vulns_per_page).offset(@vulns_offset)
    @vulns = sort_vulns(paged_vuln_set)

    @vulns_total_display_count = @vulns_total_count
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
            Mdm::Vuln.arel_table[:name]
          )
        )
      else
        vulns = Mdm::Vuln.arel_table
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
    redirect_to host_path(@vuln.host) + "#vulnerabilities"
  end

  def ref_data
    @vuln.refs.build
  end


  # Generate an include option for the tag table when loading records
  # for the Analysis tab.
  #
  # Returns the Array condition.
  def tags_include_option
    [:refs, {:host => :tags}]
  end

  def exploit_module_match_data
    module_details = Mdm::Module::Detail.arel_table

    @exploits = @vuln.module_details.where(
      :mtype => [
        'auxiliary',
        'exploit'
      ]
    ).order(
      module_details[:mtype].desc,
      module_details[:rank].desc
    )
  end

  def related_hosts_relation
    find_vuln
    #TODO: Optimize into one query?
    ref_ids = Mdm::VulnRef.select(:ref_id).where(vuln_id: @vuln.id).pluck(:ref_id)

    relation = Mdm::Host.with_table_data.related_hosts(ref_ids,@vuln.host)
  end


  def i18n_nexpose_messages
    @i18n_nexpose_messages ||= I18n.translate('activerecord.ancestors.nexpose/result.message')
  end

  def vuln_params
    params.require(:vuln).permit!
  end
end
