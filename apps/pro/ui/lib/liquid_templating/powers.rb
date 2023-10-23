# Lightweight module for adding Liquid templating (https://github.com/Shopify/liquid) functionality 
# to pieces of Metasploit Pro.
#

#
# Core
#
require 'ostruct'

#
# Gems
#
require 'liquid'

#
# Project
#
require 'liquid_templating/campaign_image'
require 'liquid_templating/campaign_web_link'
require 'liquid_templating/campaign_href'

module LiquidTemplating

  module Powers
    # 
    # Bestows the powers of LiquidTemplating on a class.  
    #
    # Class should have a content attribute that holds a Liquid template string.  
    # This content will be rendered with data that comes from variables,
    # tags, and Liquid "drops".  LiquidTemplating::Powers provides an
    # interface for declaring which classes can provide variables for
    # the class' content, as well as a white list of the variables
    # themselves.
    #
    # USAGE:
    # class Email < ApplicationRecord
    #  include LiquidTemplating::Powers
    #
    #  liquid_template :content
    #  liquid_drops SocialEngineering::HumanTarget, :first_name, :last_name, :email_address
    # end
    #
    def self.included(base)
      base.class_eval do

        # Class-level settings for doing Liquid stuff with content
        @liquid_templating_config = OpenStruct.new
        @liquid_templating_config.drops = []

        # Settings accessor
        def self.liquid_templating_config
          @liquid_templating_config
        end
        
        # Set which attribute will contain a Liquid template string
        def self.liquid_template(attr_name)
          @liquid_templating_config.template = attr_name
        end

        # Create "drops" for adding content into templates.
        # Each drop declaration is checked to see if 
        # 1) the associated class's instances respond to it
        # 2) there are no other drops with the same name
        def self.liquid_drops(klass, *attrs)
          raise ArgumentError, "first argument must be a class constant" unless klass.is_a? Class
          
          # Ensure uniqueness of drop names
          unless current_liquid_drop_attrs.empty?
            unless current_liquid_drop_attrs - attrs == current_liquid_drop_attrs
              raise ArgumentError, "one or more drop names are already taken"
            end
          end

          # If we're here, it's all good -- add the drops
          liquid_templating_config.drops << {:class => klass, :attrs => attrs}
        end

        def self.current_liquid_drop_attrs
          liquid_templating_config.drops.collect{|d| d[:attrs]}.flatten
        end

        # TODO: move this to a presenter/helper when we have one
        #
        # Create an array for use in a view as an argument to a Rails select list helper
        def self.liquid_drops_select_list_pairs
          current_liquid_drop_attrs.inject([]) do |array, item|
            item = item.to_s
            array << [item.humanize, "{{#{item}}}"]
            array
          end
        end

        #
        # Render with an object that responds to methods stored in the
        # liquid_templating_config for the drop_object's class 
        #
        def liquid_render_with_drop_object(drop_object, tracking=true)
          klass        = drop_object.class

          # Names of declared drop_object methods that will be used in
          # rendering the template content
          attr_names = self.class.liquid_templating_config.drops.detect{|d| d[:class] == klass}[:attrs]

          context = liquid_context_from_drop_object(drop_object)

          # Pack context with variable names from the drop object
          attr_names.each do |attr|
            context[attr.to_s] = drop_object.send(attr)
          end
          
          # Create template by calling template method on the class
          template_method = self.class.liquid_templating_config.template
          raw_content = self.send(template_method)
          template = Liquid::Template.parse(raw_content)
          # Use data from drop object to render final content
          full_content = template.render(context)

          # Append tracking stuff if requested
          if tracking
            full_content << liquid_tracking_gif_string(drop_object)
          else
            full_content
          end
        end


        def liquid_tracking_gif_string(drop_object)
          raise ArgumentError unless drop_object.class == SocialEngineering::HumanTarget
          tracker = SocialEngineering::Tracking.where(:email => self, :human_target => drop_object).first
          human_id = drop_object.id
          email_id = self.id
          if !self.exclude_tracking
            track_string = SocialEngineering::VisitRequest.encoded_query_params(email_id, human_id)
            # IP or domain or whatever
            web_host = self.campaign.web_host || Rex::Socket.source_address('50.50.50.50')
            # the path that names things as an email gif track
            path = SocialEngineering::VisitRequest::EMAIL_TRACKING_PATH

            # tracking string in full
            if tracker 
              full_string = "-#{tracker.uuid}"
            else
              full_string = "?#{SocialEngineering::VisitRequest::QUERY_STRING_DATA_PARAM_KEY}=#{track_string}"
            end
            port_str = self.campaign.web_port_with_colon

            if port_str == ":"
              port_str = ":#{::SocialEngineering::Campaign::DEFAULT_WEB_PORT}"
            end
            if self.campaign.web_ssl
              proto = "https"
            else
              proto = "http"
            end
            # Build the whole tag and have the built tag string be the return
            return "<img src='#{proto}://#{web_host}#{port_str}#{path}#{full_string}' width='1' height='1' style='opacity:0.0;filter:alpha(opacity=00);' >"
          else
            return ""
          end
        end


        private
        # Creates the evaluation context for rendering Liquid content.
        # Passed automatically to filters when you call Liquid::Template#render
        def liquid_context_from_drop_object(drop_object)
          context  = Liquid::Context.new
          context['render_context'] = self
          context['drop_object'] = drop_object
          context['web_host'] =  self.campaign.web_host
          context['web_port'] =  self.campaign.web_port_with_colon
          context
        end


      end # end class_eval block
    end # end self.included
  end # end Powers module
  
  #
  #
  # Register all custom tags and filters
  #
  #

  Liquid::Template.register_tag(CampaignWebLink.permanent_name, CampaignWebLink)
  Liquid::Template.register_tag(CampaignHref.permanent_name, CampaignHref)
  Liquid::Template.register_tag(CampaignImage.permanent_name, CampaignImage)

end

