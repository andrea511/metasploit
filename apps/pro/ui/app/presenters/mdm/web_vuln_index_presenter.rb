module Mdm
  class WebVulnIndexPresenter < DelegateClass(WebVuln)
    include ApplicationHelper
    include Mdm::AnalysisTabPresenter

    def as_json(opts={})
      opts.merge!( only: [ :id, :name, :blame, :pname, :path ])
      super.merge!(
          'risk' => "#{risk_label} (#{confidence}%)",
          'host.name' => host_name_html,
          'host.id' => host.id,
          'category' => category_label,
          'url' => web_vuln_path_link,
          'proof' => proof ? proof.truncate(40) : nil,
      )
    end

    private

    def web_vuln_path_link
      link_to("#{web_site.to_url}#{path}",
        Rails.application.routes.url_helpers.web_vuln_path(host.workspace, id))
    end
  end

end
