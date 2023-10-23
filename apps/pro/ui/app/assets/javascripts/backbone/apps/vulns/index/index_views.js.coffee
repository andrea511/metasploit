define [
  'base_layout'
  'base_view'
  'base_itemview'
], () ->
  @Pro.module 'VulnsApp.Index', (Index, App, Backbone, Marionette, $, _) ->
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
        workspaceVulnsPath = _.escape Routes.workspace_vulns_path WORKSPACE_ID
        text = _.escapeHTML(_.unescapeHTML(data.name)) || ''

        truncatedText = if text.length > maxLength then text.substring(0, maxLength) + '…' else text

        "<a href='#{ workspaceVulnsPath }#vulns/#{ id }'> #{ truncatedText } </a>"

    #
    # The table cell containing the host address as a link to the SHV.
    class Index.AddressCellView extends App.Views.ItemView
      template: (data) ->
        """
        <a href='#{ Routes.host_path(data.host_id) }'>#{ data['host.address'] }</a>
        """

