class MigrateTasksToFsm < ActiveRecord::Migration[4.2]
  #
  # Check the errors and completed_at attributes on a task, updating them as follows:
  #   - if task has errors, state is FAILED
  #   - if task has no errors:
  #     - if completed_at is not null, state is COMPLETED
  #     - if completed_at is null, state is INTERRUPTED
  #
  def up
    unmigrated_tasks = Mdm::Task.where(Mdm::Task[:state].eq(Mdm::Task::States::UNSTARTED).or(Mdm::Task[:state].eq(nil)))
    unmigrated_tasks.find_each do |task|
      if task.error.present?
        task.update!(state: Mdm::Task::States::FAILED)
      else
        if task.completed_at.present?
          task.update!(state: Mdm::Task::States::COMPLETED)
        else
          task.update!(state: Mdm::Task::States::INTERRUPTED)
        end
      end
    end
  end

  def down
  end
end
