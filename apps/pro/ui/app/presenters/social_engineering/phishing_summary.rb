module SocialEngineering
  class PhishingSummary
    def initialize(campaign, template)
      @campaign = campaign
      @template = template
    end

    def names_per_result
      results = PhishingResult.in_campaign(@campaign)
      results.inject({}) do |memo, result|
        memo[result] = name_for(result.human_target)
        memo
      end
    end   

    def to_s
      @template.render partial: 'social_engineering/phishing_results/summary',
                       object: self
    end

    private

    def name_for(human_target)
      if human_target.present?
        human_target.name
      else
        'Anonymous'
      end
    end
  end
end
