module SocialEngineering
  class CampaignRunner
    include ApplicationHelper

    def self.start(campaign, current_user)
      campaign.launch
      task = CampaignTask.new(campaign)
      task.start

      campaign.started_at = Time.now.utc
      campaign.started_by_user = current_user
      campaign.save!
    end

    def self.stop(campaign)
      campaign.finish
      tasks = Mdm::Task.find_running_campaign_tasks(campaign)
      tasks.each(&:rpc_stop)
    end
  end
end
