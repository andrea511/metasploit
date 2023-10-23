module Mdm
  class HostIndexPresenter < DelegateClass(Host)
    include Mdm::AnalysisTabPresenter
    include ApplicationHelper
    include ERB::Util
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::AssetTagHelper
    include Presenters::Host
    include HostsHelper
    include Rails.application.routes.url_helpers

    def as_json(opts={})
      super.merge!(
          'address'    => host_address_html,
          'name'       => host_name_html,
          'os_name'    => host_os_html,
          'updated_at' => host_updated_at_html,
          'status'     => host_status_html,
          'tags'       => host_tags_or_notes_html
      )
    end

    private

    # Generate the markup for this Mdm::Host's address.
    #
    # @return [String] the markup html
    def host_address_html
      link_to(address, host_path(self))
    end

    # Generate the markup for this Mdm::Host's name.
    #
    # @return [String] the markup html
    def host_name_html
      raw_name = name
      # if the hostname was populated from a wildcard cert, we don't want
      #   to see a huge list of e.g. *.metasploit.com
      name_is_safe = raw_name.present? && !raw_name.starts_with?("*")
      name = name_is_safe ? (json_data_scrub(raw_name)) : address
      link_to(name, host_path(self))
    end

    # Generate the markup for the host OS icons.
    #
    # @return [String] the markup html
    def host_os_html
      os_string = (os || "Unknown") + " " + os_sp.to_s
      "<img src='#{os_to_icon(os)}' class='os_icon'>#{h(json_data_scrub(os_string))}"
    end

    # Generate the markup for the host's update_at attribute.
    #
    # @return [String] the markup html
    def host_updated_at_html
      <<-HTML
      <span class='#{ (attributes['flagged_count'].to_i > 0 && recently_updated?) ? "badge" : "" }'>
        #{ updated_at ? "#{time_ago_in_words(updated_at)} ago" : "never" }
      </span>
      HTML
    end

    # Generate the markup for the host's status attribute.
    #
    # @return [String] the markup html
    def host_status_html
      text = host_status_text(self)

      # add some links to a few of the status messages
      output = case text
               when "looted"
                 link_to text.capitalize, host_path(self)+"#captured_data"
               when "cracked"
                 link_to text.capitalize, host_path(self)+"#credentials"
               when "shelled"
                 link_to text.capitalize, workspace_sessions_path(workspace)
               else
                 text.capitalize
               end

      "<div class='host_status_#{ text }'>#{ output }</div>"
    end

    # Generate the markup for the host tags or notes, depending upon the license.
    #
    # @return [String] markup html
    def host_tags_or_notes_html
      tag_count = tags_count
      if tag_count.to_i > 0
        markup = tag_html(tags.first, workspace)
        if tag_count.to_i > 1
          markup += "<img src='#{ActionController::Base.helpers.image_path('icons/list.png')}' class='tags-icon'>"
          tags_markup = ""
          tags.each do |tag|
            tags_markup += tag_html(tag, workspace)
          end
          tags_hover_html = <<-HTML
          <div class='tags-hover'>
           #{ tags_markup } <img src='#{ ActionController::Base.helpers.image_path('triangle.png')}' class='tags-hover-triangle'>
          </div>
          HTML
          markup += tags_hover_html
        end
        markup = "<div class='tags-wrap'>#{ markup }</div>"
        markup
      else
        " "
      end
    end

    # Generate the markup for the host tag, including hidden fields needed
    # for the front-end JavaScript.
    #
    # @return [String] the markup html
    def tag_html(tag, workspace)
      <<-HTML
      <div class='tag'>
        #{ link_to(h(tag.name), hosts_path(workspace) << ("?search=%23" << tag.name)) }
        <span class='tag-id invisible'>#{ tag.id.to_s }</span>
        <span class='tag-name invisible'>#{ tag.name }</span>
      </div>
      HTML
    end
  end
end
