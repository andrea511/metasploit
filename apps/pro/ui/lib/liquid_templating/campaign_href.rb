# Explicit requires for engine/prosvc.rb
require 'liquid'
require 'liquid_templating/campaign_web_link'

module LiquidTemplating
  # Implements a Liquid tag for the href to a tracked link
  #
  # @example
  #   {% campaign_href '5' %}
  #
  # The tag is coded to assume it will be rendered with
  # an instance of Liquid::Context that will provide:
  #     * campaign web_host
  #     * human target
  #     * render context (e.g. email or web page)
  class CampaignHref < LiquidTemplating::CampaignWebLink
    def self.permanent_name
      "campaign_href"
    end

    def initialize(tag_name, params, tokens)
      super
      @web_page_ref = parsed_params[0]
    end

    def num_params
      1
    end

    def missing_web_page_text
      '#'  # make sure we don't break anything
    end

    def render(context)
      assign_campaign(context)
      if missing_web_page?
        missing_web_page_text
      else
        render_url(context)
      end
    end
  end
end
