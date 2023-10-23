class Apps::BaseController < Wizards::BaseController
  before_action :load_workspace
  before_action :load_steps
  before_action :set_report_type

  #TODO: Remove TaskConfig constant check when we namespace Engines correctly
  # Sets up the routes for the metamodule (part of the Wicked wizards gem)
  def self.inherited(base)
    if base.module_parent::TaskConfig.const_defined? :STEPS
      base.steps(*base.module_parent::TaskConfig::STEPS)
    end
    super
  end

  def show
    # Not Restful because of Wicked Gem
    if base_params[:task_config_id].nil?
      report_defaults = {
          file_formats: [Report::DEFAULT_FILE_FORMAT],
          options: Report::DEFAULT_OPTIONS
      }

      build_objects(report_defaults)
      @task_config.set_defaults!
    else
      task = ScheduledTask.find(base_params[:task_config_id])
      begin
        task.form_hash[:report] = nil
        #TODO: Refactor MM Symbol to be consistent with Class name
        if task.form_hash[:mm_symbol]== "passive_network"
          @task_config = Apps::PassiveNetworkDiscovery::TaskConfig.new(task.form_hash)
        else
          @task_config = Apps.const_get(task.form_hash[:mm_symbol].camelize)::TaskConfig.new(task.form_hash)
        end

      rescue NameError => e
        @task_config = Object.const_get(task.form_hash[:mm_symbol].camelize)::TaskConfig.new(task.form_hash)
      end

      @file_upload = task.file_upload
      @report = Report.new(task.report_hash)
    end
    render :partial => "form"
  end

  # Called per step via AJAX when you are moving among the multi-page form tabs
  def validate
    build_objects

    current_context = base_params[:task_config][:task_chain].nil? ? :stand_alone : :task_chain

    if @task_config.valid?(current_context)
      render_success
    else
      render_task_errors
    end
  end

  def launch(task_chain=false)
    build_objects

    current_context = task_chain ? :task_chain : :stand_alone

    if @task_config.valid?(current_context) && @report.save
      @task_config.report = @report
      task = @task_config.launch!

      render_success(
        :path => workspace_apps_run_path(
          task.workspace.id, task.app_run_id
        )
      )
    else
      render_task_errors
    end
  end

  private

  # Builds the needed TaskConfig and Report.
  #
  # @param additional_report_params [Hash] any params to incorporate into the
  # report params from the user
  def build_objects(additional_report_params = {})
    @task_config = build_task_config

    params.permit!
    base_report_params = params.fetch(:report, {})
    report_params = @task_config.finalized_report_params(base_report_params)
      .merge({report_type: @report_type})
      .merge(additional_report_params)
      .permit!
    @report = Report.new(report_params)

    # @report = Report.new(report_params(additional_report_params))
  end

  # @return [TaskConfig] for your metamodule, configured from the form request
  def build_task_config
    task_config_params = params.fetch(:task_config, {}).merge(:no_files => params[:no_files])
    self.class.module_parent::TaskConfig.new(
      add_defaults(task_config_params),
    )
  end

  # a before_action method on all actions
  # stuffs the current_step and the list of all steps into ivars, for use in html
  def load_steps
    @steps = steps
    @current_step = step
  end

  # a before_action method on all actions.
  # adds default info (user, workspace, user_id) to the task hash
  def add_defaults(hash)
    hash ||= {}
    hash.merge(:workspace => @workspace, :username => current_user.username, :current_user => current_user)
  end

  # Determines if the task and report are valid.
  #
  # @return [Boolean] true if valid, false otherwise
  def task_valid?
    @task_config.valid? && @report.valid?
  end

  # Renders an error response.
  def render_task_errors
    render_errors(
      task_config: @task_config.errors.messages,
      report:      @report.errors.messages
    )
  end

  # Assigns the appropriate report type for the app.
  #
  # @note This method should be overridden in the app's controller.
  def set_report_type
    @report_type = nil
  end


  def base_params
    params.permit!
  end
end
