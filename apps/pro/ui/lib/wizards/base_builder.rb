class Wizards::BaseBuilder
  include TasksSharedControllerMethods

  include Wizards::TaskHelpers # we need #write_file_param_to_quickfile
  include Metasploit::Pro::AddressUtils # we want #default_ip_range

  # @attr [Hash] params the parameters from the user
  attr_accessor :params

  # @attr [Wizards::BaseForm] form the form object that we are building
  attr_accessor :form

  # @attr [Mdm::User] current_user used when looking up defaults
  attr_accessor :current_user

  def initialize(params, user)
    self.params = ActionController::Parameters.new.merge(params)
    self.current_user = user
  end

  # Sets default UI options for the user that never drills
  #   down into the "Advanced" fieldsets.
  #
  # This can yield a different result from what's returned by Form#new.
  # @return [Wizards::BaseBuilder] self
  def set_defaults!
    raise NotImplementedError, "#set_defaults! needs to be overriden in a subclass."
  end

  # After calling .build, to_procedure lets you output the snowballed
  # config to a Wizards::BaseProcedure subclass
  #
  # @return [Wizards::BaseProcedure] an initialized Procedure subclass
  #   with a populated config_hash 
  def to_procedure
    raise NotImplementedError, "#to_procedure needs to be overriden in a subclass."
  end

  # returns an initialized Wizards::BaseForms instance determined by params passed in the constructor
  #
  # @return [Wizards::BaseForm] subclass with populated attributes
  def build
    raise NotImplementedError, "#build needs to be overriden in a subclass."
  end

  protected

  #
  # build_* methods are used to build TaskConfigs of nested attributes
  #


  # Initializes (but does not save) an Mdm::Workspace for holding the results of this Wizard.
  # Attaches the initialized workspace to form.workspace.
  # The workspace is eventually saved right before the task is launched.
  def build_workspace_from_params
    params[:workspace] ||= {}
    form.workspace = Mdm::Workspace.new(workspace_params)
    form.workspace.owner ||= current_user
  end

  # Initializes an ImportTask and attaches it to form.import_task.
  def build_import_task_from_params
    params[:import_task] ||= {}
    params[:scan_task] ||= {}
    form.import_task = ImportTask.new(params[:import_task].merge({
      :workspace => form.workspace,
      :blacklist_string => params[:scan_task][:blacklist_string] || '',
      :username => current_user.username,
      :no_files => params[:no_files],
      :path => write_file_param_to_quickfile(params[:import_task][:file])
    }))
  end

  # Initializes a Report based on user's parameters,
  # attaches it to form.report.
  #
  # @param [Hash] opts the options for building the report
  def build_report_from_params(opts={})
    params[:report] ||= {}
    report_params = params[:report].merge(opts)
    report_params = report_params.merge({
      # Wizards create a new workspace:
      :skip_data_check    => true,
      :created_by         => current_user.username,
      :usernames_reported => current_user.username,
      }
    ).permit!
    form.report = Report.new(report_params)
  end

  # Initializes a CollectEvidenceTask from the user's params and attaches it to form.collect_evidences_task.
  def build_collect_evidence_task
    form.collect_evidence_task = CollectEvidenceTask.new(
      :run_on_all_sessions => true,
      :workspace => form.workspace
    )
  end

  # Initializes an ExploitTask from the user's params and attaches it to form.exploit_task.
  def build_exploit_task_from_params
    params[:exploit_task] ||= {}
    workspace = form.workspace
    expand_opts = {:workspace => workspace}
    form.exploit_task = ExploitTask.new(params[:exploit_task].merge({
      :workspace => form.workspace,
      :whitelist_string => Metasploit::Pro::AddressUtils.expand_ip_ranges(workspace.boundary, expand_opts).join("\n"),
      :username => current_user.username,
      :skip_host_validity_check => true
    }))
  end


  def build_cleanup_task
    form.cleanup_task = CleanupTask.new({
      :run_on_all_sessions => true,
      :workspace => form.workspace
    })
  end

  private

  def workspace_params
    params.fetch(:workspace, {}).permit!
  end
end
