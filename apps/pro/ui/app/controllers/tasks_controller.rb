class TasksController < ApplicationController

  include TasksSharedControllerMethods
  include TableResponder

  before_action :load_workspace, :except => [:pause, :resume, :stop, :stop_paused, :replay, :logs, :stop_all]

  before_action :load_task, :only => [:show, :pause, :resume, :replay, :stop, :stop_paused, :logs, :stats_collection]

  before_action :require_admin, :only => [:new_tunnel, :start_tunnel, :delete_imported_creds]  # Should this include :stop_all ?

  before_action :using_embedded_layout?
  layout :task_layout_selector

  has_scope :workspace_id, only: [:new_exploit, :new_bruteforce, :new_scan, :new_webscan]


  def index
    @tasks = @workspace.tasks.includes(:workspace)
    respond_to do |format|
      format.html
      format.js {
        render 'index_update' # FIX ME: For some reason this renders as mime_type undefined!
      }
    end
  end


  def gather_report_templates
    @report_templates = @workspace.report_templates.all
    @report_templates_jasper = @workspace.report_templates_jasper
    @report_templates_logos = @workspace.report_templates_logos
  end


  def edit
    @scheduled_task = ScheduledTask.find(edit_params[:id])

    case edit_params[:kind]
      when IMPORT
        @task = ImportTask.new(@scheduled_task.form_hash)
        @file_upload = @scheduled_task.file_upload
      when SCAN
        @task = ScanTask.new(@scheduled_task.form_hash)
      when EXPLOIT
        @task = ExploitTask.new(@scheduled_task.form_hash)
        @licensed = License.get.supports_exploit?
      when CLEANUP
        @task = CleanupTask.new(@scheduled_task.form_hash)
      when COLLECT
        params[:_nl] = '1'
        params[:kind] = 'collect_evidence'

        @sess_ids = (edit_params[:sess_ids] || []).map{|x| x.to_i}
        @task = CollectEvidenceTask.new(@scheduled_task.form_hash)
        @title = "Compromised Host Evidence Collection"
        @licensed = License.get.supports_collect?
      when WEBSCAN
        @licensed = License.get.supports_webapp_exploitation?
        @task = WebscanTask.new(@scheduled_task.form_hash)
      when BRUTEFORCE
        hosts = _get_hosts_by_ids_or_search(edit_params[:host_ids], edit_params[:search])
        if edit_params[:service_ids]
          services = BruteforceTask::Services.normalize_brute_services(@workspace.services.find(edit_params[:service_ids]))
        else
          services = nil
        end

        @task = BruteforceTask.new(@scheduled_task.form_hash)
        @inactive_count = 0
        @workspace.creds.each {|cred| @inactive_count += 1 unless cred.active}
        @title = "Authentication Bruteforce"
        @licensed = License.get.supports_bruteforce?
      when MODULERUN
        @scheduled_task.form_hash = @scheduled_task.form_hash.merge(:module => MsfModule.find_by_fullname(@scheduled_task.form_hash[:path]))
        @task = ModuleRunTask.new(@scheduled_task.form_hash)
        @module = @task.module
        @target_hosts = [@scheduled_task.form_hash[:whitelist_string]]
      when REPORT
        collect_report_custom_resources
        report_params = @scheduled_task.form_hash
        @report = build_sanitized_report(report_params)

        edit_params[:task_config_id] = edit_params[:id]
        @licensed = License.get.supports_reports?
        render "reports/new" , layout: !request.xhr?
        return
      when RCSCRIPT
        @rc_script = rc_script_to_hash(
            @scheduled_task.form_hash['path'],
            @scheduled_task.form_hash['canned_script'],
            @scheduled_task.form_hash['datastore_opts'],
            true
        )
        render 'new_rc_script_run', layout: !request.xhr?
        return
      when NEXPOSEPUSH
        @task = NexposeExceptionPushTask.new( cloned_settings || {
                                                  :vuln_ids  => params[:vuln_ids],
                                                  :workspace => @workspace,
                                                  :username  => current_user.username
                                              })
        @title = "Nexpose Exception Push"
        @licensed = License.get.supports_advanced_nexpose?

        if License.get.supports_vuln_validation?
          @vuln_ids = params[:vuln_ids]
          @match_set_id = params[:match_set_id]
          @nexpose_consoles = Mdm::NexposeConsole.select([:name, :id]).all.as_json
        end
        
        render 'new_nexpose_exception_push', layout: !request.xhr?, :object => @task
        return
    end

    #TODO Refactor to have task views in a shared Dir
    render "new_#{edit_params[:kind]}", layout: !request.xhr?
  end


  def show

    if request.format.js? or request.format.html?
      @logs = view_context.prettified_tasklog(@task)
    end

    respond_to do |format|
      format.html
      format.json do
        if @task.presenter_class.present?
          respond_with @task.presenter_class.new(@task, params)
        else
          respond_with @task
        end
      end
    end
  end

  def stats_collection
    collection_data = @task.presenter_class.new(@task, params).collection(params[:presenter])
    table = as_table(collection_data[:relation], collection_data[:options] || {})
    respond_to do |format|
      format.json { render json: table }
      format.csv do
        send_data table,
          :type => 'text/csv',
          :disposition => 'attachment',
          :filename => File.basename(params[:presenter])
      end
    end
  end

  def logs
    from = (params[:line] || 0).to_i
    @logs = view_context.prettified_tasklog(@task, from_line: from)
    data = {
      :header => render_to_string(:partial => 'task_header'),
      :log    => @logs
    }
    render :json => data.to_json
  end

  # Stops the specified task
  def stop
    if @task.present?
      if @task.app_run.present?
        @task.app_run.abort! # stops every task belonging to the AppRun at once.
      else
        @task.rpc_stop
      end
    end

    @task_dom_id = dom_id @task

    render 'stop_update.js.erb'
  end

  def stop_paused
    # Since the task is already stopped, we just need to transition its state.
    @task.stop!

    render json: {}, status: :ok
  end

  def resume
    execute_rpc_task_action :rpc_resume
  end

  def pause
    execute_rpc_task_action :rpc_pause
  end

  # Replays the specified task
  def replay
    case @task.settings[:task_type]
    when 'ScanTask'
      redirect_to new_scan_path(:workspace_id => @task.workspace.id, :clone_task => @task.id)
    when 'NexposeTask'
      redirect_to new_workspace_import_path(:workspace_id => @task.workspace.id, :clone_task => @task.id)
    when 'BruteforceTask'
      redirect_to new_bruteforce_path(:workspace_id => @task.workspace.id, :clone_task => @task.id)
    when 'ExploitTask'
      redirect_to new_exploit_path(:workspace_id => @task.workspace.id, :clone_task => @task.id)
    when 'CollectEvidenceTask'
      redirect_to new_collect_evidence_path(:workspace_id => @task.workspace.id, :clone_task => @task.id)
    when 'CleanupTask'
      redirect_to new_cleanup_path(:workspace_id => @task.workspace.id, :clone_task => @task.id)
    when 'WebauditTask'
      redirect_to new_webaudit_path(:workspace_id => @task.workspace.id, :clone_task => @task.id)
    when 'WebscanTask'
      redirect_to new_webscan_path(:workspace_id => @task.workspace.id, :clone_task => @task.id)
    when 'WebsploitTask'
      redirect_to new_websploit_path(:workspace_id => @task.workspace.id, :clone_task => @task.id)
    else
      render :plain => "<h1>Unable to replay this task type</h1>"
    end
  end

  # Stop all Mdm::Tasks across all Project/Workspaces in the app
  def stop_all
    stopped_ids = Mdm::Task.running.map(&:rpc_stop)
    AuditLogger.admin "#{ip_user} - Stop all tasks."
    Mdm::Task.find(stopped_ids).each do |t|
      AuditLogger.admin "#{ip_user} - Task stopped. #{t.attributes}"
    end
    flash[:notice] = "All tasks in all projects have been stopped"
    render :js => 'location.reload(true);'
  end

  # Stop all Mdm::Tasks running in the given Project/Workspace
  def stop_in_workspace
    Mdm::Task.running.where(:workspace_id => @workspace.id).map(&:rpc_stop)
    flash[:notice] = "All tasks for this project have been stopped"
    render :js => 'location.reload(true);'
  end

  # Shows a form for creating a new Scan task
  def new_scan
    addresses = if params[:host_ids]
      if params[:host_ids].blank?
        @workspace.hosts.collect { |h| h.address }
      else
        @workspace.hosts.find(params[:host_ids]).collect { |h| h.address }
      end
    elsif params[:target_addresses]
      [params[:target_addresses]]
    elsif params[:selections]
      records = records_from_selection_params( params[:class], params[:selections] )

      if records.first.try(:class) == Mdm::Host
        records = records.select( 'address' ).distinct.collect( &:address ).compact
      else
        records = records.select( Arel.star ).distinct.collect( &:host ).compact
        records = Mdm::Host.find(records.pluck(:id))
      end

      records
    else
      @workspace.addresses
    end

    @task = ScanTask.new( cloned_settings || {
      :addresses => addresses.map(&:to_s),
      :workspace => @workspace,
      :username  => current_user.username
    })
    @title = "Host and Service Discovery"

    render layout: !request.xhr?
  end


  # Validate a form for created a new Scan Task
  def validate_scan
    @task_config = process_task_config(:scan, params[:scan_task], false)

    if @task_config.valid?
      render :json => {success: true, errors: @task_config.error}
    else
      render :json => {success: false, errors: @task_config.error}
    end
  end

  # Starts a new Scan task
  def start_scan
    process_task_config(:scan, params[:scan_task], true)
  end


  # Shows a popup with a form for creating a new Import task
  def new_import
    @task = ImportTask.new(
        :workspace => @workspace,
        :username  => current_user.username
    )

    @title = "Data Import"
    render layout: !request.xhr?
  end

  # Starts a nexpose scan and import task
  def start_scan_and_import
    process_task_config(:scan_and_import, params,true)
  end

  def validate_scan_and_import
    @task_config = process_task_config(:scan_and_import, params, false)

    if @task_config.valid?
      render json: {success: true}, status: :ok
    else
      render json: {errors: @task_config.errors} , status: :bad_request
    end

  end

  # Starts a new Import task
  def start_import
    process_task_config(:import, params, true)
  end

  #Validate import
  def validate_import
    params[:no_files] = true;

    params[:validate_file_path] = false unless params[:use_last_uploaded].blank?
    @task_config = process_task_config(:import, params, false)

    if @task_config.valid?
      render :json => {success: true, errors: @task_config.error}
    else
      render :json => {success: false, errors: @task_config.error}
    end
  end

  # Shows a popup with a form for creating a new Exploit task
  def new_exploit
    hosts = if params[:host_ids] or params[:search]
      _get_hosts_by_ids_or_search(params[:host_ids], params[:search])
    elsif params[:selections]
      records = records_from_selection_params( params[:class], params[:selections] )

      if records.first.try(:class) == Mdm::Host
        records = records.select( 'address' ).distinct.to_a.compact
      else
        records = records.select( Arel.star ).distinct.collect( &:host ).compact
        records = Mdm::Host.find(records.pluck(:id))
      end

      records
    else
      @workspace.hosts.all
    end

    @task = ExploitTask.new( cloned_settings || {
      :whitelist => hosts.collect { |h| h.address },
      :workspace => @workspace,
      :username  => current_user.username
    })
    @title = "Automated Exploitation"
    @licensed = License.get.supports_exploit?
    render layout: !request.xhr?
  end

  # Validate an Exploit Task
  def validate_exploit
    @task_config = process_task_config(:exploit, params[:exploit_task],false)

    if @task_config.valid?
      render :json => {success: true, errors: @task_config.error}
    else
      render :json => {success: false, errors: @task_config.error}
    end
  end

  # Start a new Exploit task
  def start_exploit
    @licensed = License.get.supports_exploit?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end
    process_task_config(:exploit, params[:exploit_task], true)
  end


  # Shows a popup with a form for creating a new NexposeAssetGroupPush task
  def new_nexpose_asset_group_push
    hosts = _get_hosts_by_ids_or_search(params[:host_ids], params[:search])
    @task = NexposeAssetGroupPushTask.new( cloned_settings || {
      :tag_ids   => params[:tag_ids],
      :whitelist => hosts.collect { |h| h.address },
      :workspace => @workspace,
      :username  => current_user.username
    })
    @title = "Nexpose Asset Group Push"
    @licensed = License.get.supports_advanced_nexpose?
  end

  # Start a new Exploit task
  def start_nexpose_asset_group_push
    @licensed = License.get.supports_advanced_nexpose?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end
    process_task_config(:nexpose_asset_group_push, params[:nexpose_asset_group_push_task], true)
  end

  # Shows a popup with a form for creating a new NexposeExceptionPush task
  # XXX: Use VulnIDs not HostIDs
  def new_nexpose_exception_push
    #TODO: Refactor Method
    respond_to do |format|
      format.html{
        @task = NexposeExceptionPushTask.new( cloned_settings || {
            :vuln_ids  => params[:vuln_ids],
            :workspace => @workspace,
            :username  => current_user.username
        })
        @title = "Nexpose Exception Push"
        @licensed = License.get.supports_advanced_nexpose?

        if License.get.supports_vuln_validation?
          @vuln_ids = params[:vuln_ids]
          @match_set_id = params[:match_set_id]
          @nexpose_consoles = Mdm::NexposeConsole.select([:name, :id]).all.as_json
        end

        if params[:task_chain]
          render layout: !request.xhr?, :object => @task
          return
        end
      }
      format.json{
        result_exceptions = []


        #TODO: Only group by things with vuln defs.
        if params[:vuln_ids].empty? and !params[:match_set_id].empty?
          matches = MetasploitDataModels::AutomaticExploitation::Match.failed_match_results.by_match_set_id(params[:match_set_id]).group_by(&:vuln_def)
        else

          if params[:match_set_id].empty?
            matches = MetasploitDataModels::AutomaticExploitation::Match.failed_match_results.by_console_and_vuln_ids(params[:console_id],params[:vuln_ids]).group_by(&:vuln_def)
          else
            matches = MetasploitDataModels::AutomaticExploitation::Match.failed_match_results.by_console_and_vuln_ids(params[:console_id],params[:vuln_ids]).by_match_set_id(params[:match_set_id]).group_by(&:vuln_def)
          end

        end

        matches.each do |key, val|
          module_detail = key.title
          exceptions = []

          val.each do |match|
            existing_exception = ::Nexpose::Result::Exception.where(automatic_exploitation_match_result_id: match.match_results.first.id)

            result_code = match.matchable.vuln_attempts.count > 0? match.matchable.vuln_attempts.last.fail_reason : "none"

            if existing_exception.count > 0
              existing_exception.each do |e|
                result_exception = e.as_json.merge({
                                                       host_address: match.matchable.host.address,
                                                       automatic_exploitation_match_result_id: match.match_results.first.id,
                                                       result_code: result_code
                                                   })
                exceptions << result_exception
              end
            else
              result_exception =  ::Nexpose::Result::Exception.new()
              result_exception  = result_exception.as_json.merge({
                                                                     host_address: match.matchable.host.address,
                                                                     automatic_exploitation_match_result_id: match.match_results.first.id,
                                                                     result_code: result_code
                                                                 })
              exceptions << result_exception
            end
          end
          result_exceptions << ::Nexpose::Result::ExceptionPresenter.new(result_exceptions: exceptions, module_detail: module_detail)
        end
      render json: result_exceptions
      }
    end

  end

  def validate_nexpose_exception_push
    @task_config = process_task_config(:nexpose_exception_push, params, false)

    render json: {success: true}, status: :ok
  end

  # Start a new Exploit task
  def start_nexpose_exception_push
    @licensed = License.get.supports_advanced_nexpose?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end
    process_task_config(:nexpose_exception_push, params[:nexpose_exception_push_task], true)
  end

  # Shows a popup with a form for creating a new Replay
  def new_replay
    @licensed = License.get.supports_replay?
    @task = ReplayTask.new( cloned_settings || {
      :workspace => @workspace,
      :username  => current_user.username
    })
    @title = "Automated Attack Replay"
  end

  # Start a new Replay task
  def start_replay
    @licensed = License.get.supports_replay?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end

    @replay_task = ReplayTask.new(params[:replay_task].merge({:username => current_user.username}))

    if (@task = @replay_task.start)
      redirect_to(task_detail_path(@task.workspace, @task.id))
    else
      @task = @replay_task
      render "new_replay"
    end
  end

  # Shows a popup with a form for creating a new Websploit task
  def new_websploit
    @licensed = License.get.supports_webapp_exploitation?

    hosts = nil
    if params[:host_ids]
      hosts = @workspace.hosts.find(params[:host_ids])
    end

    if params[:site_ids]
      hosts = Mdm::WebSite.find(params[:site_ids]).map{|w| w.service.host}.select{|host| host.workspace_id == @workspace[:id]}
    end

    hosts ||= @workspace.hosts

    @title = "Web Application Vulnerability Exploitation"
    @task  = WebsploitTask.new( cloned_settings || {
      :whitelist => hosts.collect { |h| h.address },
      :workspace => @workspace,
      :username  => current_user.username
    })
  end

  # Start a new Websploit task
  def start_websploit
    @licensed = License.get.supports_webapp_exploitation?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end

    @websploit_task = WebsploitTask.new(params[:websploit_task].merge({:username => current_user.username}))
    if (@task = @websploit_task.start)
      render_new_task(@task)
    else
      render_task_errors(@websploit_task)
    end
  end

  # Shows a popup with a form for creating a new Webscan task
  def new_webscan
    @licensed = License.get.supports_webapp_exploitation?

    hosts = nil
    hosts = if params[:host_ids]
      @workspace.hosts.find(params[:host_ids])
    elsif params[:site_ids]
      Mdm::WebSite.find(params[:site_ids]).map{|w| w.service.host}.select{|host| host.workspace_id == @workspace[:id]}
    elsif params[:selections]
      records = records_from_selection_params( params[:class], params[:selections] )

      unless records.first.try(&:class) == Mdm::Host
        records = records.collect( &:host )
      end

      records.to_a.compact.uniq
    end

    hosts ||= @workspace.hosts

    @title = "Web Application Reconnaissance"
    @task  = WebscanTask.new( cloned_settings || {
      :whitelist => hosts.collect { |h| h.address },
      :targeted  => params[:host_ids] ? true : false,
      :workspace   => @workspace,
      :username  => current_user.username
    })

    render layout: !request.xhr?
  end

  # Validate a Webscan Task
  def validate_webscan
    @task_config = process_task_config(:webscan, params[:webscan_task],false)

    if @task_config.valid?
      render :json => {success: :ok, errors: @task_config.error}
    else
      render :json => {success: false, errors: @task_config.error}
    end
  end

  # Start a new Webscan task
  def start_webscan
    @licensed = License.get.supports_webapp_exploitation?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end
    process_task_config(:webscan, params[:webscan_task], true)
  end

  # Shows a popup with a form for creating a new Webaudit task
  def new_webaudit
    @licensed = License.get.supports_webapp_exploitation?

    hosts = nil
    if params[:host_ids]
      hosts = @workspace.hosts.find(params[:host_ids])
    end

    if params[:site_ids]
      hosts = Mdm::WebSite.find(params[:site_ids]).map{|w| w.service.host}.select{|host| host.workspace_id == @workspace[:id]}
    end

    hosts ||= @workspace.hosts.all

    @title = "Web Application Vulnerability Scanning"
    @task  = WebauditTask.new( cloned_settings || {
      :whitelist => hosts.collect { |h| h.address },
      :workspace => @workspace,
      :username  => current_user.username
    })
  end

  # Start a new Webaudit task
  def start_webaudit
    @licensed = License.get.supports_webapp_exploitation?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end

    @webaudit_task = WebauditTask.new(params[:webaudit_task].merge({:username => current_user.username}))
    if (@task = @webaudit_task.start)
      render_new_task(@task)
    else
      render_task_errors(@webaudit_task)
    end
  end

  # Shows a popup with a form for creating a new Bruteforce task
  def new_bruteforce
    hosts = _get_hosts_by_ids_or_search(params[:host_ids], params[:search])
    if params[:service_ids]
      services = BruteforceTask::Services.normalize_brute_services(@workspace.services.find(params[:service_ids]))
    else
      services = nil
    end

    @task = BruteforceTask.new( cloned_settings || {
      :whitelist => hosts.collect { |h| h.address },
      :brute_services => services,
      :workspace => @workspace,
      :username  => current_user.username
    })
    @inactive_count = 0
    @workspace.creds.each {|cred| @inactive_count += 1 unless cred.active}
    @title = "Authentication Bruteforce"
    @licensed = License.get.supports_bruteforce?
    render layout: !request.xhr?
  end

  # Start a new Bruteforce task
  def start_bruteforce
    @licensed = License.get.supports_bruteforce?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end

    process_task_config(:bruteforce, params[:bruteforce_task], true)
  end

  #Validate Bruteforce Task
  def validate_bruteforce
    @task_config = process_task_config(:bruteforce, params[:bruteforce_task], false)

    if @task_config.valid?
      render :json => {success: :ok, errors: @task_config.error}
    else
      render :json => {success: false, errors: @task_config.error}
    end
  end

  # Validate a Nexpose task
  def validate_nexpose
    @task_config = process_task_config(:nexpose, params[:nexpose_task],false)

    if @task_config.valid?
      render :json => {success: :ok}
    else
      render :json => {success: false, errors: @task_config.error}
    end
  end

  # Start a new Nexpose task
  def start_nexpose
    process_task_config(:nexpose, params[:nexpose_task], true)
  end

  # Shows a popup with a form for creating a new CollectEvidence task
  def new_collect_evidence
    @sess_ids = (params[:sess_ids] || []).map{|x| x.to_i}
    @task = CollectEvidenceTask.new( cloned_settings || {
      :workspace => @workspace,
      :username  => current_user.username
    })
    @title = "Compromised Host Evidence Collection"
    @licensed = License.get.supports_collect?
    render layout: !request.xhr?
  end


  def start_collect_evidence
    @licensed = License.get.supports_collect?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end
    process_task_config(:collect_evidence, params[:collect_evidence_task], true)
  end


  # Shows a popup with a form for creating a new Cleanup task
  def new_cleanup
    @sess_ids = (params[:sess_ids] || []).map{|x| x.to_i}
    @task = CleanupTask.new( cloned_settings || {
      :workspace => @workspace,
      :username  => current_user.username
    })
    @title = "Compromised Host Cleanup"
    render layout: !request.xhr?
  end

  def start_cleanup
    process_task_config(:cleanup, params[:cleanup_task], true)
  end

  def new_upgrade_sessions
    @sess_ids = (params[:sess_ids] || []).map{|x| x.to_i}
    @task = UpgradeSessionsTask.new( cloned_settings || {
      :workspace => @workspace,
      :username  => current_user.username
    })
    @title = "Windows CMD Shell Upgrade"
  end

  def start_upgrade_sessions
    process_task_config(:upgrade_sessions, params[:upgrade_session_task], true)
  end

  def new_module_run
    @clone           = params[:clone_id]
    @target_hosts    = [params[:target_host] || nil].compact
    @options         = params[:options] || {}
    @sessions        = params[:sessions]

    if params[:host_ids]
      @target_hosts = Mdm::Host.find(params[:host_ids]).map{|host| host.address}
    end


    if @clone
      # CloneID is either a session_open or a module_run event ID
      ev = @workspace.events.find(@clone)

      if not (ev and ev.info and ev.info[:datastore])
        render :plain => "<h1>Missing event information</h1>"
        return
      end

      @options = ev.info[:datastore]


      # This may be deprecated after #4140, not 100% sure tho.
      if ev.name == "session_open"
        @module          = MsfModule.find_by_fullname( ev.info[:via_exploit] )
        @target_hosts    << (ev.info[:target_host] || ev.info[:tunnel_peer] || '').split(':')[0]
      end

      if ev.name == "module_run"
        @module          = MsfModule.find_by_fullname( ev.info[:module_name] )
        @target_hosts    << @options['RHOST'] || @options['RHOSTS'] || ''
      end
    else
      @module = find_module_by_path
    end
    if @target_hosts.length == 0
      @target_hosts = @workspace.addresses
    end

    @task = ModuleRunTask.new( cloned_settings || {
      :module  => @module,
      :workspace => @workspace,
      :options => @options,
      :target  => @module.default_target,
      :sessions => @sessions
    })

    # RPORT option needs to be set after otherwise all other options on the new module run form are cleared/empty
    # @see ModuleRunTask#set_module_options why this is the case.
    @task.options['RPORT'] = params[:target_port].to_i if params[:target_port]
  end

  def new_rc_script_run
    @rc_script = rc_script_to_hash(
        "#{params[:path]}.#{params[:format]}",
        params[:canned_script],
        params[:datastore_opts],
        true
    )
    render layout: !request.xhr?
  end

  def validate_rc_script_run
    @task_config = process_task_config(:rc_script, params, false)
    if @task_config.valid?
      render :json => {success: :ok, errors: @task_config.error}
    else
      render :json => {success: false, errors: @task_config.error}
    end
  end

  def session_reopen
    @session = Mdm::Session.find(params[:id])

    if @session.via_exploit == "auxiliary/scanner/ssh/ssh_login_pubkey" && @session.datastore['CRED_CORE_PRIVATE_ID']
      begin
        cred_core_private_id = @session.datastore['CRED_CORE_PRIVATE_ID']
        cred_core_private_data = Metasploit::Credential::Private.find(cred_core_private_id).data
        temp_key_file = Tempfile.new('ssh_replay_key')
        temp_key_file.write(cred_core_private_data)
        temp_key_file.rewind
        @session.datastore['PRIVATE_KEY'] = "file:#{temp_key_file.path}"
        @session.datastore['TempKeyFile'] = temp_key_file
      rescue ActiveRecord::RecordNotFound => e
        @session.datastore['CRED_CORE_PRIVATE_ID'] = nil
        @session.datastore['PRIVATE_KEY'] = nil
      end
    end

    @options = @session.datastore
    @module  = MsfModule.find_by_fullname(@session.via_exploit)
    @target_hosts = [@options['RHOST'] || @options['RHOSTS'] || '']

    @task = ModuleRunTask.new(
      :module  => @module,
      :workspace => @workspace,
      :options => @options,
      :target  => @module.default_target,
      :sessions => @sessions,
      :explicit_falses => true
    )

    render :action => 'new_module_run'
  end

  def start_module_run
    process_task_config(:module_run, params[:module_run_task], true)
  end

  def validate_module_run
    @task_config = process_task_config(:module_run, params[:module_run_task], false)

    if @task_config.rpc_valid?
      render :json => {success: :ok, errors: @task_config.error}
    else
      render :json => {success: false, errors: @task_config.error}
    end
  end

  # Shows a popup with a form for creating a new Tunnel task
  def new_tunnel
    @licensed = License.get.supports_vpn_pivot?

    if not @licensed
      render_popup("Network Tunnel Configuration", "generic/disabled_overlay")
      return
    end


    @interface_names = %W{ }
    @sess = params[:sess_id]
    interfaces = {}

    @c = Pro::Client.get

    perr = nil
    begin
      res = @c.call("pro.meterpreter_tunnel_interfaces", @sess)
      if res and res["result"] == "success" and res["interfaces"]
        interfaces = res["interfaces"]
      else
        perr = res["error"].to_s
      end
    rescue ::Exception => e
    end

    valid = {}
    interfaces.each_key do |k|
      int = interfaces[k]
      next if not (int['address'] and int['netmask'])
      next if int['address'] == '0.0.0.0'

      # Determine what source address we would use to route to this network
      saddr = Rex::Socket.source_address(int['address'])
      scidr = Rex::Socket.addr_atoc(int['netmask']) rescue nil
      next if not scidr

      # Does this address fall within the same subnet of the remote interface?
      range = Rex::Socket::RangeWalker.new("#{saddr}/#{scidr}")
      next if not range
      next if range.include?(int['address'])
      valid[k] = int
    end

    @task = TunnelTask.new(
      :workspace        => @workspace,
      :username       => current_user.username,
      :interfaces     => valid,
      :all_interfaces => interfaces,
      :error          => perr
    )
    AuditLogger.admin "#{ip_user} - New tunnel task. #{@task.as_json}"
    render_popup("Network Tunnel Configuration", "new_tunnel")
  end

  def start_tunnel
    @licensed = License.get.supports_vpn_pivot?
    if not @licensed
      render :plain => "<h1>Unlicensed</h1>"
      return
    end

    @tunnel_task = TunnelTask.new(params[:tunnel_task].merge({:username => current_user.username}))
    if (@task = @tunnel_task.start)
      AuditLogger.admin "#{ip_user} - Tunnel task started. #{@task.as_json}"
      render_new_task(@task)
    else
      render_task_errors(@tunnel_task)
    end
  end

  def new_transport_change
    @sess = params[:sess_id]
    @task = TransportChangeTask.new(transport: 'reverse_tcp', lhost: '0.0.0.0')
    render_popup("Meterpreter Transport Change", "new_transport_change")
  end

  def start_transport_change
    @transport_task = TransportChangeTask.new(params[:transport_change_task])
    if (@transport_task.rpc_call)
      render_js_redirect(workspace_sessions_path(@workspace))
    else
      render_task_errors(@transport_task)
    end
  end

  private

  def edit_params
    params[:kind] = (VALID_TASKS.include? params[:kind]) ? params[:kind] : ''

    params.permit!
  end

  def load_task
    @task = Mdm::Task.find(params[:id])
  end

  def execute_rpc_task_action(action)
    if @task.present?
      @task.send(action)
      render json: {}, status: :ok
    else
      render json: {}, status: :bad_request
    end
  end

  def render_new_task(task)
    if request.xhr?
      render_js_redirect(task_detail_url(task.workspace, task))
    else
      redirect_to task_detail_url(task.workspace, task)
    end
  end


  def render_task_errors(task)
    render 'errors_update', :locals => { :task => task }
  end

  def _get_hosts_by_ids_or_search(ids, search)
    if ids
      @workspace.hosts.find(ids)
    elsif search
      search_terms = Shellwords.shellwords(search) rescue search.split(/\s+/)

      hosts = @workspace.hosts
      search_terms.each do |term|
        if term =~ /^#(.*)/
          hosts = hosts.tag_search($1)
        else
          hosts = hosts.search(term)
        end
      end
      hosts
    end
  end

  def cloned_settings
    return nil if not params[:clone_task]
    clone = Mdm::Task.find( params[:clone_task] )
    return nil if not clone
    return nil if not clone.settings
    return nil if not clone.settings[:task_type]
    settings = clone.settings.dup
    settings.delete(:task_type)

    # Fix up address strings
    if settings[:address_string]
      settings[:addresses] = settings.delete(:address_string).split(/\s+/)
    end

    # Fix up booleans for checkboxes
    settings.each_pair do |k,v|
      settings[k] = false if v == "false"
      settings[k] = true  if v == "true"
    end

    settings
  end
end

