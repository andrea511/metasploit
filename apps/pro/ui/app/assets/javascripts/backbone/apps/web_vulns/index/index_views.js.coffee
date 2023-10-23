define [
  'base_layout'
  'base_view'
  'base_itemview'
], () ->
  @Pro.module 'WebVulnsApp.Index', (Index, App, Backbone, Marionette, $, _) ->
    #
    # The table cell containing the host address as a link to the SHV.
    class Index.AddressCellView extends App.Views.ItemView
      template: (data) ->
        """
        <a href='#{ Routes.host_path(data.host_id) }'>#{ data['host.address'] }</a>
        """

