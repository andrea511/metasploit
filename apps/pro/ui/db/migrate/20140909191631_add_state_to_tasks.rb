class AddStateToTasks < ActiveRecord::Migration[4.2]
  def up
    add_column :tasks, :state, :string, default: 'unstarted'

    Mdm::Task.reset_column_information

    say_with_time "Updating state of existing Mdm::Tasks" do
      Mdm::Task.find_each do |task|
        if task.error && task.completed_at
          task.update_attribute :state, 'failed'
        elsif task.completed_at
          task.update_attribute :state, 'completed'
        else
          task.update_attribute :state, 'running'
        end
      end
    end
  end

  def down
    remove_column :tasks, :state
  end
end
