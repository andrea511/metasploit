module Mdm::Task::Campaign
  extend ActiveSupport::Concern

  module ClassMethods

    def find_running_campaign_tasks(campaign)
      campaign_id = campaign.id
      tasks = []
      running.each do |task|
        tasks << task if (task.options['DS_CAMPAIGN_ID'] == campaign_id)
      end
      tasks
    end

    def find_campaign_tasks(campaign)
      Mdm::Task.where(workspace_id: campaign.workspace_id).select do |task|
        task.options['DS_CAMPAIGN_ID'] == campaign.id
      end
    end

  end
end
