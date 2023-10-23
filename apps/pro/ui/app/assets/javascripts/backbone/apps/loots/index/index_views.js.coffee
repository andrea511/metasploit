define [
  'base_view'
  'base_itemview'
], () ->
  @Pro.module 'LootsApp.Index', (Index, App, Backbone, Marionette, $, _) ->
    #
    # The table cell containing links to view/download the loot data
    class Index.DataCellView extends Pro.Views.ItemView
      ui:
        noteDataDisclosureLink: 'a.loot-data-view'

      events:
        'click @ui.noteDataDisclosureLink': 'displayModal'

      template: (data) ->
        data['data']

      displayModal: (e) ->
        $dialog = $("<div style='display:hidden'>#{@$el.find('.loot-data').html()}</div>").appendTo('body')
        $dialog.dialog
          title: "Loot data"
          maxheight: 530
          width: 670
          buttons:
            "Close": ->
              $(this).dialog('close')
        e.preventDefault()