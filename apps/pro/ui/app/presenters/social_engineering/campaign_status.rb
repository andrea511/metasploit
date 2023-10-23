module SocialEngineering
  class CampaignStatus
    include ActiveSupport::Inflector

    def initialize(campaign)
      @campaign = campaign
    end

    def current_state
      humanize(@campaign.state)
    end

    def executable?
      @campaign.executable?
    end

    def css_class
      return '' if not executable?
      if @campaign.startable?
        'start'
      else
        'stop'
      end
    end

    def confirmation
      return false if not executable?
      if @campaign.startable?
        'Are you sure you wish to start this campaign? All emails will be irreversibly sent.'
      else
        'Are you sure you wish to stop this campaign? This will take any campaign web pages offline.'
      end
    end

    def next_execute_action
      return '' if not executable?
      if @campaign.startable?
        'Start'
      else
        'Stop'
      end
    end
  end
end
