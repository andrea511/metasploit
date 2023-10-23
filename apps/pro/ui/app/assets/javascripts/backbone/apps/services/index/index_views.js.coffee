define [
  'base_view'
  'base_itemview'
], () ->
  @Pro.module 'ServicesApp.Index', (Index, App, Backbone, Marionette, $, _) ->
    #
    # The table cell containing the truncated service info
    class Index.InfoCellView extends Pro.Views.ItemView

      initialize: () ->
        @attribute = 'info'
        @idAttribute = 'id'

      template: (data) =>
        maxLength = 50
        id = data[@idAttribute]
        text = data[@attribute] || ''

        truncatedText = if text.length > maxLength then text.substring(0, maxLength) + '…' else text
        _.escapeHTML(_.unescapeHTML(truncatedText))

    #
    # The table cell containing the state info
    class Index.StateCellView extends Pro.Views.ItemView

      template: (data) =>
        """
        <div class='pill'> <div class='#{data.state}'> #{ data.state.toUpperCase() } </div></div>
        """
