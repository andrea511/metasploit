module Mdm
  # Shared methods for presenting data on the analysis tabs.
  module AnalysisTabPresenter
    include ActionView::Helpers::UrlHelper
    include ApplicationHelper

    # Generate the markup for a related Mdm::Host's name.
    #
    # @return [String] the markup html
    def host_name_html
      raw_name = host.name
      # if the hostname was populated from a wildcard cert, we don't want
      #   to see a huge list of e.g. *.metasploit.com
      name_is_safe = raw_name.present? && !raw_name.starts_with?("*")
      name = name_is_safe ? (json_data_scrub(raw_name)) : host.address
      link_to(name, Rails.application.routes.url_helpers.host_path(host))
    end
  end
end