# Explicit requires for engine/prosvc.rb
require 'liquid'

module LiquidTemplating
  # Implements a Liquid tag for a local image
  #
  # @example
  #   {% campaign_web_link 'click here',you-are-a-winner %}
  #
  # The tag is coded to assume it will be rendered with
  # an instance of Liquid::Context that will provide:
  #     * campaign vhost
  #     * human target
  #     * render context (e.g. email or web page)
  class CampaignImage < Liquid::Tag
    attr_reader :parsed_params, :img_src

    def self.permanent_name
      "campaign_image"
    end

    # params should be like "/path/to/img"
    def initialize(tag_name, params, tokens)
      super
      @parsed_params = TagParams.parse(params, 1)
      @img_src = parsed_params[0]
      @style = (parsed_params.size > 1) ? parsed_params[1] : ''
    end

    def render(context)
      url = @img_src
      if Rails.env == 'development'
        root_url = 'http://localhost/'
        img_src_uri = ::URI.parse(@img_src) rescue nil

        if img_src_uri.present?  # convert host name to http://localhost
          img_src_relative_uri = ::URI.parse(img_src_uri.path)
          root_uri = ::URI.parse(root_url)
          url = (root_uri + img_src_relative_uri).to_s
        end
      end
      "<img src=\"#{url}\" style=\"#{@style}\"/>"
    end
  end
end
