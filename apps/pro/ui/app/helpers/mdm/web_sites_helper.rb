module Mdm::WebSitesHelper
  def mdm_web_sites_link(name, args)
    path_args = { :workspace_id => @workspace.id, :page => args[:page], :n => @sites_per_page }
    path_args[:search] = params[:search] if params[:search]
    path_args[:sort_by] = params[:sort_by] if params[:sort_by]
    path_args[:sort_dir] = params[:sort_dir] if params[:sort_dir]
    html_options = args[:html_options] || {}
    link_to name, web_sites_path(path_args), html_options
  end

  def mdm_web_site_risk_tag(site)
    risks = site.web_vulns.map(&:risk)
    risk = risks.max
    risk ||= 0

    if risk == 0 and site.web_forms.length == 0
      risk_label = 'Unaudited'
    else
      risk_label = Mdm::WebVuln.risk_label(risk)
    end

    klass = "mdm-web-vuln-risk #{risk_label.underscore}"
    tag = content_tag(
        :div,
        risk_label,
        :class => klass
    )

    tag
  end
end