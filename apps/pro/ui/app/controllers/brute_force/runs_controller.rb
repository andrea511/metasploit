# Used to kick off a BruteForce::Run
class BruteForce::RunsController < ApplicationController

  before_action :load_workspace

  respond_to :json

  def create
    run = BruteForce::Run.new(run_params)

    if run.save
      # Create the BruteForce::Reuse::Attempt objects in the database
      run.create_attempts(params[:core_ids], params[:service_ids])

      # kick off the task across the RPC bridge
      task_data = Pro::Client.get.start_brute_force_reuse(
        'DS_BRUTEFORCE_RUN_ID' => run.id,
        'workspace'            => @workspace.name,
        'username'             => current_user.username
      )

      # set the Task's presenter so that we get the nice custom stats display
      task = Mdm::Task.find(task_data['task_id'])
      task.presenter = :brute_force_reuse
      task.save

      # attach the task to the bruteforce run
      run.task_id = task.id
      run.save

      # tell the client it's all good and to redirect
      render json: { success: true, redirect_to: task_detail_path(@workspace, task) }
    else
      # you have to mess up pretty bad to get here, gtfo
      render status: :error, json: { success: false, errors: run.errors.full_messages }
    end   

  end

  private

  def run_params
    params.fetch(:run, {}).permit!
  end

end
