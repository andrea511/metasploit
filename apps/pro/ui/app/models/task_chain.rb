# Explict requires for engine/prosvc.rb
require 'state_machines'

class TaskChain < ApplicationRecord

  #
  # Non-Persisted Attribute
  #
  attr_accessor :schedule_info

  has_many :scheduled_tasks,
           -> { order('position ASC') },
           :dependent => :destroy

  belongs_to :active_scheduled_task, :class_name => 'ScheduledTask', optional: true
  belongs_to :active_task, :class_name => 'Mdm::Task', optional: true
  belongs_to :last_run_task, :class_name => 'Mdm::Task', optional: true
  belongs_to :active_report, :class_name => 'Report', optional: true
  belongs_to :last_run_report, :class_name => 'Report', optional: true
  belongs_to :user, :class_name => 'Mdm::User'
  belongs_to :workspace, :class_name => 'Mdm::Workspace'

  #
  # Serializations
  #

  serialize :schedule, IceCube::Schedule
  serialize :schedule_hash
  #
  # Scopes
  #

  scope :for_workspace, lambda { |workspace| where(:workspace_id => workspace.id)}

  # Consider a task chain `interrupted` if the last_run_task is in error state and still listed as the active_task
  # This is based on the state machine below which clears the active_task_id when the chain transitions from `running` to `ready`.
  # example query based on this scope:
  # SELECT "task_chains".*
  #   FROM "task_chains"
  #   INNER JOIN "tasks" ON "tasks"."id" = "task_chains"."last_run_task_id"
  # WHERE "tasks"."state" = 'interrupted'
  #   AND "task_chains"."last_run_task_id" = "task_chains"."active_task_id"
  scope :interrupted, lambda {
    joins(
      TaskChain.join_association(:last_run_task)
    )
      .where(Mdm::Task[:state].eq(Mdm::Task::States::INTERRUPTED))
      .and(
        TaskChain.where(TaskChain.arel_table[:last_run_task_id].eq(TaskChain.arel_table[:active_task_id]))
      )
  }

  #
  # State Machines
  #

  state_machine :state, :initial => :ready do
    event :suspend do
      transition ready: :suspended, running: :suspended
    end
    event :ready do
      transition suspended: :ready
    end
    event :start do
      transition ready: :running
    end
    event :finish do
      transition running: :ready
    end

    before_transition any => :ready                 do |task_chain, transition|
      if task_chain.schedule
        task_chain.next_run_at = task_chain.schedule.next_occurrence.utc
      end
    end

    before_transition any => [:suspended, :running] do |task_chain, transition|
      task_chain.next_run_at = nil
    end

    before_transition any => :running               do |task_chain, transition|
      task_chain.last_run_at = Time.now.utc
    end

    before_transition :running => :ready            do |task_chain, transition|
      task_chain.active_task_id = nil
      task_chain.active_scheduled_task_id = nil
    end

  end

  #
  # Validations
  #

  validates :name, presence: true, uniqueness: {scope: :workspace_id}, length: {maximum: 255}
  validates :user, :presence => true
  validates :workspace, :presence => true
  # TODO next_run_at and last_run_at need to be valid Time

  # Flag to tell the task runner to wipe out existing
  # Workspace data before starting first task in chain.
  def clear_workspace_before_run?
    clear_workspace_before_run.present?
  end

  def print_scheduled_kinds
    str = ''
    scheduled_tasks.each_with_index do |task, i|
      str << ', ' if i > 0
      str << task.kind.humanize
    end
    str
  end

  def scheduled_to_run?
    self.next_run_at.present?
  end

  def schedule_to_run_at(time)
    return if time.nil?
    self.next_run_at = time
  end

  def self.cleanup!
    if table_exists?
      where(state: "running").find_each do |task_chain|
        # setting the state to skip the transitions.
        task_chain.state = "ready"
        task_chain.save
      end
    end
  end

  # Create a copy of the chain, and each of its tasks.
  #
  # @return [TaskChain] the copied task chain
  def copy
    copied_task_chain = self.dup

    copy_scheduled_tasks_to(copied_task_chain)
    copied_task_chain.remove_run_references!
    # Remove last run timestamp.
    copied_task_chain.last_run_at = nil
    # Explicitly reset state to ready (to avoid transitions).
    copied_task_chain.state = 'ready'
    mutate_name_for_copy(copied_task_chain)

    copied_task_chain
  end

  # Remove references for last and active runs.
  def remove_run_references!
    self.active_scheduled_task = nil
    self.active_task = nil
    self.last_run_task = nil
    self.active_report = nil
    self.last_run_report = nil
  end

  def as_json(options = nil)
    super(options).merge({schedule_info: self.schedule_info})
  end

  private

  # Attach each of this chain's tasks to another chain.
  #
  # @param task_chain [TaskChain] the task chain on which to attach the cloned tasks
  def copy_scheduled_tasks_to(task_chain)
    scheduled_tasks.each do |task|
      task_chain.scheduled_tasks << task.dup
    end
  end

  # Create a timestamped name when copying a task chain.
  #
  # @param task_chain [TaskChain] the copied chain to rename
  def mutate_name_for_copy(task_chain)
    time = Time.now.to_i
    task_chain.name = "#{name}_cloned_#{time}"
  end
end
