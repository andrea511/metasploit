class RemoveBruteforceTaskChainFileReferences < ActiveRecord::Migration[5.2]
  def up
    ScheduledTask.where(kind: 'bruteforce').find_each do |scheduled_bruteforce_task|
      next unless scheduled_bruteforce_task[:file_upload]
      workspace = scheduled_bruteforce_task[:form_hash][:workspace]
      task_chain_id = scheduled_bruteforce_task[:task_chain_id]

      scheduled_bruteforce_task[:file_upload] = nil
      form_hash = scheduled_bruteforce_task[:form_hash]
      form_hash[:quick_bruteforce][:use_last_uploaded] = ''
      form_hash[:clone_file_warning] = 'false'

      file_pair_count = form_hash[:file_pair_count].to_i
      unless file_pair_count == 0
        form_hash[:file_pair_count] = '0'
        form_hash[:import_pair_count] = "#{form_hash[:import_pair_count].to_i - file_pair_count}"
      end
      scheduled_bruteforce_task.save!
      
      create_notification_message(workspace, task_chain_id)
    end
  end

  def down
  end

  def create_notification_message(workspace, task_chain_id)
    Notifications::Message.create(
      workspace: workspace,
      title: "Task Chain Bruteforce Task Changed",
      url: "/workspaces/#{workspace[:id]}/task_chains/#{task_chain_id}/edit",
      content: "To prevent errors with the task chain, the file import was automatically removed.",
      kind: :task_notification
    )
  end
end
