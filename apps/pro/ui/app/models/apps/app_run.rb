class Apps::AppRun < ApplicationRecord
  # Raised anytime a configuration setup for an App doesn't work
  class AppRunConfigurationError < Exception; end

  # Run our state transitions OUTSIDE of transaction block
  include AfterCommitQueue

  # Lets make this public so that we don't need to call .send in
  #  our after_transition callbacks.
  # Allows us to run logic in an after_transition callback that
  #  escapes the implicit transaction involved in running transition
  #  events.
  public :run_after_commit

  #
  # Constants
  #
  STOPPED_STATES = [:completed, :failed, :aborted]

  #
  # Associations
  #
  belongs_to :app, class_name: 'Apps::App'
  belongs_to :workspace, class_name: 'Mdm::Workspace'
  has_many :tasks, class_name: 'Mdm::Task'
  has_many :run_stats, through: :tasks
  serialize :config, JSON

  #
  # Named scopes
  #

  scope :done, -> { where('state IN (?)', STOPPED_STATES) }
  scope :not_done, -> { where('state NOT IN (?)', STOPPED_STATES) }


  # -- STATE MACHINE
  # states:
  #   -- requested
  #   -- started
  #   -- running
  #   -- waiting
  #   -- reportable
  #   -- completed
  #   -- failed
  #   -- aborted

  state_machine :state, :initial => :requested do
    event :start! do
      transition :requested => :started
    end

    event :run! do
      transition :started => :running
    end

    event :wait! do
      transition :running => :waiting
    end

    event :enable_report! do
      transition [:running, :waiting] => :reportable
    end

    event :complete! do
      transition [:waiting, :reportable, :running] => :completed
    end

    event :fail! do
      transition [:requested, :started, :waiting, :reportable, :running] => :failed
    end

    event :abort! do
      transition [:requested, :started, :waiting, :reportable, :running] => :aborted
    end

    after_transition any => :started do |app_run, transition|
      app_run.update(:started_at => Time.now)
    end

    after_transition any => STOPPED_STATES do |app_run, transition|
      app_run.update(:stopped_at => Time.now)
    end

    after_transition any => [:aborted] do |app_run, transition|
      app_run.run_after_commit do
        # This can get run during prosvc startup, so don't want error when we can't reach it
        begin
          app_run.tasks.each(&:rpc_stop)
        rescue Rex::ConnectionRefused => e
        end
      end
    end
  end

  # @return [Boolean] App is no longer running
  def done?
    STOPPED_STATES.include? state.to_sym
  end

  Metasploit::Concern.run(self)
end
