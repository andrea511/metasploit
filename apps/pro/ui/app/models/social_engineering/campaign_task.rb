class SocialEngineering::CampaignTask < TaskConfig
	attr_accessor :campaign

	def initialize(campaign)
		super({
      :campaign => campaign,
      :workspace => campaign.workspace
    })
    @campaign = campaign
	end

	def rpc_call
		client.start_se_campaign({
			'workspace' => @workspace.name,
			'DS_CAMPAIGN_ID' => @campaign.id
		})
	end
end
