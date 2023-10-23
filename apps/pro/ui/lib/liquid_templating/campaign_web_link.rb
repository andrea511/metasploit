# Explicit requires for engine/prosvc.rb
require 'liquid'

module LiquidTemplating
  class UnexpectedContextObject < Exception; end

  # Implements a Liquid tag for a tracked link
  #
  # @example
  #   {% campaign_web_link 'click here',you-are-a-winner %}
  #
  # The tag is coded to assume it will be rendered with
  # an instance of Liquid::Context that will provide:
  #     * campaign web_host
  #     * human target
  #     * render context (e.g. email or web page)
  #
  # @deprecated Use `<a href="{% campaign_href '5' %}"` instead!
  #
  class CampaignWebLink < Liquid::Tag
    attr_reader :parsed_params, :link_text, :campaign_objects, :campaign, :web_page_ref

    def self.permanent_name
      "campaign_web_link"
    end

    # params should be like "'click here',you-are-a-winner"
    def initialize(tag_name, params, tokens)
      super
      @parsed_params = TagParams.parse(params, num_params)
      @link_text = parsed_params[0]
      @web_page_ref = parsed_params[1]
    end

    def num_params
      2
    end

    # Assumes that Liquid::Template#render will be called with a 
    # Liquid::Context object on which the proper things have
    # been declared.
    def render(context)
      assign_campaign(context)
      if missing_web_page?
        missing_web_page_text
      else
        "<a href='#{render_url(context)}'>#{link_text}</a>"
      end
    end

    def render_url(context)
      @campaign_objects = context.scopes.first

      web_host = campaign_objects['web_host']
      web_port = campaign_objects['web_port']# if web_port is 80, hide the web_port
      human    = campaign_objects['drop_object']
      email    = campaign_objects['render_context']

      raise UnexpectedContextObject unless email.is_a? SocialEngineering::Email

      query_param_key  = SocialEngineering::VisitRequest::QUERY_STRING_DATA_PARAM_KEY
      tracking = SocialEngineering::Tracking.where(:email => email, :human_target => human).first
      query_param_data = tracking.uuid if tracking

      unless query_param_data
        query_param_data = SocialEngineering::VisitRequest.encoded_query_params(email.id, human.id)
      end

      query_string = "#{query_param_key}=#{query_param_data}"
      full_url = "#{web_page.url}?#{query_string}"
    end

    # Find web_page by web_page_ref, which can be an id OR a name
    def web_page
      if web_page_ref.is_a? Integer or web_page_ref =~ /^[\d]+$/
        @web_page ||= SocialEngineering::WebPage.find_by_id(web_page_ref.to_i)
      else
        @web_page ||= SocialEngineering::WebPage.where(:campaign_id => campaign.id, :name => web_page_ref).first
      end
    end

    def missing_web_page?
      web_page.blank?
    end

    def missing_web_page_text
      '*** WEB PAGE IS NO LONGER AVAILABLE ***'
    end

    def link_path
      web_page.path
    end

    protected

    def assign_campaign(context)
      @campaign_objects = context.scopes.first
      email    = campaign_objects['render_context']
      @campaign ||= email.campaign
    end
  end
end
