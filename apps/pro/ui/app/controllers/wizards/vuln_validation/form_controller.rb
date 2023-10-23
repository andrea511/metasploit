class Wizards::VulnValidation::FormController < Wizards::BaseController
  # Wicked gem autogenerates the routes for each step of the wizard
  steps :create_project,
        :pull_nexpose,
        :tag,
        :exploit,
        :generate_report

  helper TasksHelper # we need the report_types helper

  skip_before_action :setup_wizard, only: [ :import_run, :continue_exploitation, :nexpose_consoles_collection, :nexpose_sites ]

  # render entire blank form
  def show
    @consoles = nexpose_consoles_collection
    @builder = Wizards::VulnValidation::Builder.new({}, current_user).set_defaults!
    @form = @builder.form
    @report = @form.report
  end

  # Runs the input through a [Wizards::VulnValidation::Builder], which populates
  #   a [Wizards::VulnValidation::Form]'s attributes to contain TaskConfigs,
  #   which we then pass to [Wizards::VulnValidation::Validator] to judge.
  def validate
    @form = Wizards::VulnValidation::Builder.new(vuln_validation_params || {}, current_user).build
    @validator = Wizards::VulnValidation::Validator.new(@form)
    if @validator.step_is_valid? step
      render_success
    else
      render_errors_from_validator(@validator)
    end
  end

  # Run validations one more time, and then kick off the pentest module.
  def launch
    @builder = Wizards::VulnValidation::Builder.new(vuln_validation_params || {}, current_user)
    @form = @builder.build
    @validator = Wizards::VulnValidation::Validator.new(@form)
    if @validator.steps_are_valid? steps # run all stepz
      if @form.report
        @form.report.workspace = @form.workspace
        @form.report.save
      end
      @procedure = @builder.to_procedure
      if @procedure.save
        # make the RPC call and redirect to task page
        tid = Wizards::VulnValidation::TaskConfig.new(@procedure).rpc_call["task_id"]
        # make the Procedure remember its original Mdm::Task task_id
        @procedure.config_hash[:task_id] = tid
        @procedure.save
        # attach the VulnValidation "app" and create a hidden AppRun :)
        vv_app = Apps::App.find_by_symbol(:vuln_validation)

        app_run = Apps::AppRun.create(:app => vv_app, :workspace => @form.workspace)
        Mdm::Task.find(tid).update(:app_run_id => app_run.id)
        # render now!
        render_success :path => task_detail_path(@procedure.workspace.id, tid)
      else
        # this should never happen. render an error and return.
        # user will see an alert() error.
        render_errors_from_validator(@validator)
      end
    else
      render_errors_from_validator(@validator)
    end
  end

  # If available, looks up the Sites on a specific Nexpose::Console
  def nexpose_sites
    @console = Mdm::NexposeConsole.find params[:nexpose_console_id]

    import_run = NexposeImporter.new(
                                    console:@console,
                                    current_user: current_user
                                    ).run

    respond_to do |format|
      format.json { render json: import_run }
    end
  end

  # Renders json stats about the ImportRun (specified by :id param)
  def import_run
    @import_run = ::Nexpose::Data::ImportRun.find(params[:id])
    Nexpose::Data::Site.new
    render json: @import_run.as_json.merge(
      :sites => @import_run.sites,
      :templates => Nexpose::Data::ScanTemplate.where(:nx_console_id => @import_run.console.id)
    )
  end

  # When a Wizards::VulnValidation::Procedure is run as a "Dry run" (no exploitation),
# the user can continue the exploitation by clicking the "Continue" button, which
  # calls this endpoint to kick off the procedure again.
  def continue_exploitation
    @procedure = Wizards::VulnValidation::Procedure.find(params[:procedure_id])
    tid = Wizards::VulnValidation::TaskConfig.new(@procedure).resume_rpc_call["task_id"]
    Mdm::Task.find(tid).update({ :completed_at => nil, :error => nil })
    render_success({ task_id: tid })
  end

  private

  # @return [Hash<String, Integer>] map of Nexpose Console name -> Console ID
  # for rendering as an HTML <select> collection
  def nexpose_consoles_collection
    Mdm::NexposeConsole.order('created_at DESC')
      .each_with_object({}) { |c, obj| obj[c.name] = c.id }
  end

  def vuln_validation_params
    params.slice(:vuln_validation, :nexpose_scan_task, :custom_tag,
                 :exploit_task, :report, :workspace).permit!
  end
end
