define [
  'base_layout'
  'base_view'
  'base_itemview'
], () ->
  @Pro.module 'RelatedModulesApp.Index', (Index, App, Backbone, Marionette, $, _) ->
    #
    # The table cell containing the vulnerability name view, containing a link
    # to the single vuln view.
    class Index.NameCellView extends Pro.Views.ItemView

      initialize: ( @attribute, @idAttribute ) ->
        @attribute ?= 'name'
        @idAttribute ?= 'id'

      template: (data) =>
        maxLength = 75
        id = data[@idAttribute]
        workspaceRelatedModulesPath = _.escape Routes.workspace_related_modules_path WORKSPACE_ID
        text = data.name || ''

        truncatedText = if text.length > maxLength then text.substring(0, maxLength) + '…' else text

        "<a href='#{ workspaceRelatedModulesPath }#vulns/#{ id }'> #{ truncatedText } </a>"

    #
    # The table cell containing the vulnerability name view, containing a link
    # to the single vuln view.
    class Index.DateCellView extends App.Views.ItemView
      template: (data) =>
        """
        <div>#{data.disclosure_date.split(' ').join('&nbsp')}</div>
        """

    #
    # The table cell containing the host address as a link to the SHV.
    class Index.AddressCellView extends App.Views.ItemView
      template: (data) ->
        hosts = JSON.parse(data.hosts)
        mapped_hosts = hosts.map (h) -> h.address
        """
        <a title='#{ _.escape data.info}' href='#{ Routes.new_module_run_path({workspace_id: WORKSPACE_ID, path: data["module"] })}?target_host=#{mapped_hosts.join(", ")}'>#{ data["name"] }</a>
        """

    #
    # The table cell containing the host address as a link to the SHV.
    class Index.VulnerabilityCellView extends App.Views.ItemView
      template: (data) ->
        module_vulns = JSON.parse(data.module_vulns)
        uniqueVulns = _.uniq(module_vulns, (m) -> m.name)
        module_vulns_mapped = uniqueVulns.map (vuln) ->
          safe_name = _.escapeHTML(_.unescapeHTML(vuln.name))
          vuln_display = safe_name.match(/(CVE|USN|MS)((-\d{4}-\d{1,7})|(\d{2}-\d{1,4}))/g) || safe_name
          vuln_title = safe_name
          "<a title='#{ _.escape vuln_title}' href='#{Routes.workspace_vuln_path(WORKSPACE_ID, vuln.id)}'>" + vuln_display + '</a>'
        """
         #{ module_vulns_mapped.join(', ')}&nbsp(#{data.module_vulns_count})
        """

    #
    # The table cell containing the host address as a link to the SHV.
    class Index.HostAddressCellView extends App.Views.ItemView
      template: (data) ->
        hosts = JSON.parse(data.hosts)
        lessThanThreeHosts = if hosts.length > 3 then hosts[..2] else hosts
        hosts_mapped = lessThanThreeHosts.map (host) -> "<a title='#{host.address}: #{host.service_names.join(", ")}' href='#{Routes.host_path(host.id)}'>" + (host.name || host.address) + '</a>'
        """
        #{ hosts_mapped.join(', ') }#{ if hosts.length > 3 then '...' else ''  }&nbsp(#{data.module_hosts_count})
        """
