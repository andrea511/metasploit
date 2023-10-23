# Holds code that enables a common interface for processing task configuration
# forms in both the TasksController and TaskChainsController views.

# -- RETURN CONFIG VS RENDERING VIEW --
# The launch_now boolean is used to determine whether to start the task now
# (and render an HTTP response)  or to simply return the finished config
# object for use in creating a ScheduledTask object for persistence.
#
# It's assumed that in the case of the latter, a wrapper method is
# handling the work of rendering an HTTP response.

module TasksSharedControllerMethods

# CONSTANTS

# Whitelist of tasks
IMPORT = "import"
SCAN = "scan"
EXPLOIT = "exploit"
CLEANUP = "cleanup"
COLLECT  = "collect"
COLLECTEVIDENCE = "collect_evidence"
WEBSCAN = "webscan"
BRUTEFORCE = "bruteforce"
MODULERUN = "module_run"
REPORT = "report"
RCSCRIPT = "rc_script"
NEXPOSEPUSH = "nexpose_push"


# Valid values for params[:kind]
VALID_TASKS = [
  IMPORT,
  SCAN,
  EXPLOIT,
  CLEANUP,
  COLLECT,
  COLLECTEVIDENCE,
  WEBSCAN,
  BRUTEFORCE,
  MODULERUN,
  REPORT,
  RCSCRIPT,
  NEXPOSEPUSH
]

private

  include ReportsSharedControllerMethods
  include ::Nexpose::Result::Export

  def process_task_config(task_type, task_params, launch_now=false)
    send("process_#{task_type}", task_params, launch_now)
  end


  def process_metamodule(task_params,launch_now)
    #TODO Implement Launch Now
    report= task_params[:report]
    task_params.delete(:report)
    opts = {task_config: task_params, report: report }

    build_metamodule_object(opts)
  end

  #TODO Refactor to not be in task
  def process_report(task_params, launch_now)
    report_params = task_params.merge(:workspace_id => @workspace.id)
    @report = build_sanitized_report(report_params)
    @report
  end


  def process_bruteforce(task_params, launch_now)
    @bruteforce_task = BruteforceTask.new(task_params.merge({:username => current_user.username}))
    if launch_now
      if (@task = @bruteforce_task.start)
        render_new_task(@task)
      else
        render_task_errors(@bruteforce_task)
      end
    else
      return @bruteforce_task
    end
  end

  def process_nexpose_asset_group_push(task_params, launch_now)
    @nx_task = NexposeAssetGroupPushTask.new(task_params.merge({:username => current_user.username}))
    if launch_now
      if (@task = @nx_task.start)
        render_new_task(@task)
      else
        render_task_errors(@nx_task)
      end
    else
      return @nx_task
    end
  end

  def process_nexpose_exception_push(task_params, launch_now)
    @nx_task = NexposeExceptionPushTask.new(task_params.merge({:username => current_user.username}))
    if launch_now
      if (@task = @nx_task.start)
        render_new_task(@task)
      else
        render_task_errors(@nx_task)
      end
    else
      return @nx_task
    end
  end

  def process_nexpose_push(task_params, launch_now)
    @nx_task = Nexpose::ExceptionValidationPush::TaskConfig.new(
        :workspace => @workspace,
        :export_run_id => generate_export_run_for_workspace_vulns.id,
        :username => current_user.username
    )
    if launch_now
      if (@task = @nx_task.start)
        render_new_task(@task)
      else
        render_task_errors(@nx_task)
      end
    else
      return @nx_task
    end
  end

  def process_cleanup(task_params, launch_now)
    @cleanup_task = CleanupTask.new(task_params.merge({:username => current_user.username}))
    if launch_now
      if (@task = @cleanup_task.start)
        render_new_task(@task)
      else
        render_task_errors(@cleanup_task)
      end
    else
      return @cleanup_task
    end
  end

  def process_upgrade_sessions(task_params, launch_now)
    @upgrade_sessions_task = UpgradeSessionsTask.new(task_params.merge({:username => current_user.username, :workspace => @workspace}))
    if launch_now
      if (@task = @upgrade_sessions_task.start)
        render_new_task(@task)
      else
        render_task_errors(@upgrade_sessions_task)
      end
    else
      return @upgrade_sessions_task
    end
  end


  def process_collect_evidence(task_params, launch_now)
    if task_params[:workspace_id].nil?
      task_params[:workspace_id] = @workspace.id
    end
    @collect_task = CollectEvidenceTask.new(task_params.merge({:username => current_user.username}))
    if launch_now
      if (@task = @collect_task.start)
        render_new_task(@task)
      else
        render_task_errors(@collect_task)
      end
    else
      return @collect_task
    end
  end

  def process_exploit(task_params, launch_now)
    @exploit_task = ExploitTask.new(task_params.merge({:username => current_user.username}))
    if launch_now
      if params[:back]
        @task = @exploit_task
        render "new_exploit"
      elsif (@task = @exploit_task.start)
        redirect_to(task_detail_path(@task.workspace, @task.id))
      else
        @task = @exploit_task
        @show_new_exploit_error = true # workaround for #4096
        render "new_exploit"
      end
    else
      return @exploit_task
    end
  end

  def process_scan_and_import(task_params,launch_now)
    task_params.merge!(
                 workspace: @workspace,
                 user: @current_user,
                 launch_now: launch_now
    )

    @scan_and_import_task = Nexpose::ScanAndImport::TaskConfig.new(task_params)

    if launch_now
      if (@task = @scan_and_import_task.start)
        respond_to do |format|
          format.json {
            render json: {success: true, redirect_url: task_detail_path(@task.workspace, @task)}
          }
        end
      else
        respond_to do |format|
          format.json do
            render json: {errors: @scan_and_import_task.errors}, status: :bad_request
          end
        end
      end
    # Launching on a schedule
    else
      return @scan_and_import_task
    end
  end

  def process_import(task_params, launch_now)
    temp = nil
    path = nil
    if task_params.present? and task_params[:file].present?
      # Write the uploaded file to a tempfile
      temp = ::Rex::Quickfile.new('import')
      uploaded_io = task_params[:file]

      begin
        while (buff = uploaded_io.read(1024*64))
          temp.write(buff)
        end
      rescue ::EOFError
      end

      temp.flush
    else
      temp = nil
    end

    @import_task = ImportTask.new(
        task_params.merge(
            :path => (temp ? temp.path : nil),
            :username => current_user.username)
    )
    @import_task.workspace = @workspace

    temp = nil


    # Launching now
    if launch_now
      if (@task = @import_task.start)
        respond_to do |format|
          format.html do
            redirect_to task_detail_path(@task.workspace, @task)
          end
          format.js do
            render_new_task(@task)
          end
        end
      else
        respond_to do |format|
          format.html do
            render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => false, errors: @import_task.error}}
          end
          format.js do
            render_task_errors(@import_task)
          end
        end
      end

    # Launching on a schedule
    else
      return @import_task
    end
  end

  def process_module_run(task_params, launch_now)
    task_params.merge!({
      :username  => current_user.username,
      :workspace => @workspace,
      # XXX - look into making everything use either :select_action or just :action
      :action    => task_params[:selected_action]
    })

    if launch_now
      task_params[:module] = find_module_by_path
      @module_run_task = ModuleRunTask.new(task_params)
      if (@task = @module_run_task.start)
        flash[:notice] = "Task started"
        redirect_to task_detail_path(@workspace, @task)
      else
        flash[:error] = @module_run_task.error
        redirect_to new_module_run_path(@workspace, @module_run_task.module.fullname)
      end
    else
      task_params[:module] = find_module_by_path(task_params[:path])
      @module_run_task = ModuleRunTask.new(task_params)
      return @module_run_task
    end
  end

  def process_nexpose(task_params, launch_now)
    @nexpose_task = NexposeTask.new(task_params.merge({:username => current_user.username}))
    if launch_now
      if (@task = @nexpose_task.start)
        # Save preferences if the user has no existing nexpose settings
        if not current_user.nexpose_host
          current_user.nexpose_creds_type = @nexpose_task.nexpose_creds_type
          current_user.nexpose_creds_user = @nexpose_task.nexpose_creds_user
          current_user.nexpose_creds_pass = @nexpose_task.nexpose_creds_pass
          current_user.save!
        end
        render_new_task(@task)
      else
        render_task_errors(@nexpose_task)
      end
    else
      return @nexpose_task
    end
  end

  def process_scan(task_params, launch_now)
    @scan_task = ScanTask.new(task_params.merge(:username => current_user.username))
    if launch_now
      if (@task = @scan_task.start)
        render_new_task(@task)
      else
        render_task_errors(@scan_task)
      end
    else
      return @scan_task
    end
  end

  def process_rc_script(task_params, launch_now)
    @rc_script_task = RcLaunchTask.new(
      task_params.merge({
        workspace: @workspace,
        username: current_user.username,
        rc_path: rc_script_full_path(task_params[:path], task_params[:canned_script])
      })
    )
    if launch_now
      if (@task = @rc_script_task.start)
        flash[:notice] = "Task started"
        redirect_to task_detail_path(@workspace, @task)
      else
        flash[:error] = @rc_script_task.error
        redirect_to new_rc_script_run_path(@workspace, @rc_script_task.rc_path)
      end
    else
      return @rc_script_task
    end
  end

  def canned_rc_script_dir
    File.join(Msf::Config.script_directory, "resource")
  end

  def rc_script_full_path(filename, canned_script)
    root = if canned_script
             canned_rc_script_dir
           else
             locations.pro_rc_scripts_directory
           end
    "#{root}/#{filename}"
  end

  def rc_contents(full_path)
    File.read(full_path)
  end

  def rc_script_to_hash(filename, canned_script, datastore_opts, contents = false)
    Hash.new.tap do |rc_script|
      rc_script[:filename]       = filename
      rc_script[:canned_script]  = canned_script
      rc_script[:datastore_opts] = datastore_opts
      rc_script[:contents]       = rc_contents(rc_script_full_path(filename, canned_script)) if contents
    end
  end

  # Convenience reference to get common application locations:
  include Msf::Pro::Locations
  def locations
    @_locations ||= Object.new.extend(Msf::Pro::Locations)
  end

  def process_webscan(task_params, launch_now)
    @webscan_task = WebscanTask.new(task_params.merge({:username => current_user.username}))
    if launch_now
      if (@task = @webscan_task.start)
        render_new_task(@task)
      else
        render_task_errors(@webscan_task)
      end
    else
      return @webscan_task
    end
  end

  # Probably a temporary thing, requires the 20110928101300_add_mod_ref_table migration
  def populate_module_reference_table
    Mdm::ModRef rescue raise "The MsfModule migration 20110928101300_add_mod_ref_table has not been committed yet!"
    modules_and_refs = []
    MsfModule.all.each do |m|
      next if m.references.nil? || m.references.empty?
      this_mod = [m.fullname,m.references.map {|r| r.join("-")}.join("\n"),m.type]
      modules_and_refs << this_mod
    end
    modules_and_refs.each do |mod,ref,type|
      m = Mdm::ModRef.where(:module => mod).first_or_create
      m.ref = ref
      m.mtype = type
      m.save if m.changed?
    end
  end

  # Load via URL path from route or from other named param
  def find_module_by_path(lookup_param=nil)
    if lookup_param
      MsfModule.find_by_fullname(lookup_param)
    else
      MsfModule.find_by_fullname(params[:path])
    end
  end

  def build_metamodule_object(opts={})
    task_config = build_metamodule_task_config(opts[:task_config])

    base_report_params = opts[:report]
    report_params = task_config.finalized_report_params(base_report_params)
    .merge({report_type: @report_type})

    {task_config: task_config, report: report_params}
  end

  def build_metamodule_task_config(task_config)

    #TODO: Fix Inconsistent MM Symbol and Class name
    if task_config[:mm_symbol] == "passive_network"
      @report_type = Apps::PassiveNetworkDiscovery::TaskConfig::REPORT_TYPE
      Apps::PassiveNetworkDiscovery::TaskConfig.new(task_config)
    else
      @report_type =  Apps.const_get(task_config[:mm_symbol].camelize)::TaskConfig::REPORT_TYPE
      Apps.const_get(task_config[:mm_symbol].camelize)::TaskConfig.new(task_config)
    end

  end

end
