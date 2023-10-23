module SocialEngineering
  module PhishingResultsHelper
    def phishing_summary_for(campaign=@campaign)
      PhishingSummary.new(campaign, self)
    end
  end
end
