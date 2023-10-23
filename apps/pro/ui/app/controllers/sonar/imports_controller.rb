class Sonar::ImportsController < ApplicationController

  include TableResponder

  #
  # Before Filters
  #
  before_action :load_workspace

  #
  # Actions
  #

  # If the POST request comes from carpenter we then kickoff the Sonar import,
  # if not, we kick off a Sonar discovery import
  #
  # @return [Hash] the json response based on whether or not the import run was successfully started
  def create
    if is_table?
      process_sonar_import
    else
      process_sonar_discovery_import
    end
  end

  private

  # Takes an existing import run and filters the {Sonar::Data::Fdns} records
  # to the entries selected from the carpenter table, and kicks off
  # the `Mdm::Host` and `Mdm::Service` generation.
  #
  # @return [Hash] the json response based on whether or not the import run was successfully started
  def process_sonar_import
    import_run = Sonar::Data::ImportRun.where(workspace_id: @workspace.id,
                                              user_id: current_user.id,
                                              id: sonar_import_params[:import_run_id]

    ).first

    #Records from table
    fdnsRecords = apply_search_scopes(import_run.fdns, sonar_import_params)

    #Remove unselected records from import run
    import_run.choose_fdnss(fdnsRecords.pluck(:id))

    task_config = Metasploit::Pro::UI::Sonar::Import::TaskConfig.new(
      import_run: import_run,
      workspace: @workspace,
      tags: sonar_import_params[:tags],
      discovery: false
    )

    respond_json(task_config,import_run)
  end

  # Creates an import run that creates {Sonar::Data::Fdns} records. These records populate the temp sonar table
  # used to select which entries to import into the workspace.
  #
  # @return [Hash] the json response based on whether or not the sonar discovery import run was successfully started
  def process_sonar_discovery_import
    import_run = create_import_run

    task_config = Metasploit::Pro::UI::Sonar::Import::TaskConfig.new(
      import_run: import_run,
      workspace: @workspace
    )

    respond_json(task_config,import_run)
  end

  # Creates the Import Run
  #
  # @return [Sonar::Data::ImportRun] the sonar import run
  def create_import_run
    params.require(:import)
    Sonar::Data::ImportRun.create(workspace_id: @workspace.id,
                                               user_id:current_user.id,
                                               domain: sonar_discovery_import_params[:import][:domain],
                                               last_seen: sonar_discovery_import_params[:import][:last_seen]
    )
  end

  # Responds with a JSON response depending on the state of the task config and import run.
  #
  # @param task_config [Metasploit::Pro::UI::Sonar::Import::TaskConfig] the import run task config
  # @param import_run [Sonar::Data::ImportRun] the sonar data import run
  #
  # @return [Hash] the json response based on whether or not the import run was successfully started
  def respond_json(task_config,import_run)
    #If task config not valid
    unless task_config.valid?
      invalid_response(task_config)
    else
      if import_run.valid?
        task = task_config.start

        # If task created by RPC bridge
        if task
          successful_response(import_run,task)
        else
          rpc_failure_response
        end
      else
        invalid_response(import_run)
      end
    end
  end


  # JSON response with import run and task data
  #
  # @param import_run [Sonar::Data::ImportRun] the sonar data import run
  # @param task [Mdm::Task] the Mdm::Task containing task progress
  #
  # @return [Hash{ id: String, task_id: String, success: String }] the reference to the import run
  # and the task kicked off for that import run.
  def successful_response(import_run,task)
    respond_to do |format|
      format.json do
        render json: {
                 id: import_run.id,
                 task_id: task.id,
                 success: true
               }
      end
    end
  end

  # JSON response with error hash for task config
  #
  # @param task_config [Metasploit::Pro::UI::Sonar::Import::TaskConfig] the import run task config
  #
  # @return [Hash { errors: Hash, success: String }]
  def task_invalid_response(task_config)
    respond_to do |format|
      format.json {
        render json: {
                 errors:  task_config.errors,
                 success: false
               },
               status: :unprocessable_entity
      }
    end
  end

  # JSON response with error hash for the model
  #
  # @param model [ApplicationRecord] the model to validate
  #
  # @return [Hash { errors: Hash, success: String }]
  def invalid_response(model)
    respond_to do |format|
      format.json {
        render json: {
                 errors:  model.errors,
                 success: false
               },
               status: :unprocessable_entity
      }
    end
  end

  # JSON response with error hash for RPC error
  #
  # @return [Hash { errors: { base: String } }, success: String]
  def rpc_failure_response
    respond_to do |format|
      format.json do
        render json: {
                 errors: {
                   base: 'Remote procedure call did not generate a Task'
                 },
                 success: false
               },
               status: :bad_gateway
      end
    end
  end


  # Param whitelist for sonar discovery
  #
  # @return [Hash] the memoized whitelisted params
  def sonar_discovery_import_params
    @sonar_discovery_import_params ||= params.permit!
  end

  # Param whitelist for sonar import
  #
  # @return [Hash] the memoized whitelisted params
  def sonar_import_params
    @sonar_import_params ||= params.permit!
  end

  # adjust controller response to account for bad requests.
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    error = {}
    error[parameter_missing_exception.param] = ['parameter is required']
    response = { errors: [error] }
    render json: response, status: :unprocessable_entity
  end
end
