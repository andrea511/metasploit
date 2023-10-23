#
# Base class for a presenter object that takes a Task and returns
# run stats and a schema for displaying statistics in the UI.
#
class Tasks::BasePresenter
  include Apps::AppPresenters::Status

  def self.stats
    []
  end

  # @attr [Mdm::Task] the Task that is running the BruteForce Reuse module
  attr_reader :task

  def initialize(task, params)
    @task = task
    @params = params
  end

  def collection(name)
    if self.respond_to? name
      self.send(name)
    end
  end

  def as_json(opts={})
    task.as_json(opts).merge(
      run_stats: task.run_stats.as_json(only: [:name, :data]),
      running: task.running?,
      paused: task.paused?,
      pausable: task.pausable?
    )
  end

  private

  def app_run_status
    if app_run = Apps::AppRun.joins(:tasks).where(tasks: { id: task.id }).last
      status_for_app_run(app_run)
    end
  end

end
