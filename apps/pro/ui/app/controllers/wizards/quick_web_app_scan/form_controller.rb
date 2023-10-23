class Wizards::QuickWebAppScan::FormController < Wizards::BaseController
  # Wizard autogenerates the routes for each step of the wizard
  steps :create_project,
        :configure_authentication,
        :configure_web_audit,
        :configure_web_sploit,
        :generate_report

  # render entire blank form
  def show
    @builder = Wizards::QuickWebAppScan::Builder.new({}, current_user).set_defaults!
    @form = @builder.form
    @report = @form.report
  end

  # alias of :update
  # Runs the input through a [QuickWebAppScan::Builder], which
  # populates a [QuickWebAppScan::Form]'s attributes to contain TaskConfigs,
  # which we then pass to [QuickWebAppScan::Validator] to judge.
  def validate
    @form = Wizards::QuickWebAppScan::Builder.new(form_params || {}, current_user).build
    @validator = Wizards::QuickWebAppScan::Validator.new(@form)
    if @validator.step_is_valid? step
      render_success
    else
      render_errors_from_validator(@validator)
    end
  end

  # alias of :create
  # 
  def launch
    @builder = Wizards::QuickWebAppScan::Builder.new(form_params || {}, current_user)
    @form = @builder.build
    @validator = Wizards::QuickWebAppScan::Validator.new(@form)
    if @validator.steps_are_valid? steps # run all stepz
      if @form.report
        @form.report.workspace = @form.workspace
        @form.report.save
      end
      @procedure = @builder.to_procedure
      if @procedure.save
        # make the RPC call and redirect to task page
        tid = Wizards::QuickWebAppScan::TaskConfig.new(@procedure).rpc_call["task_id"]
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

  private

  def form_params
    params.permit!
  end
end
