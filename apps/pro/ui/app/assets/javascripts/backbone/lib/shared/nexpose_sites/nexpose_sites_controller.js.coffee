define [
  'base_controller',
  'lib/shared/nexpose_sites/nexpose_sites_views'
  'css!css/shared/nexpose_sites'
], ->
  @Pro.module "Shared.NexposeSites", (NexposeSites, App) ->
    class NexposeSites.Controller extends App.Controllers.Application

      initialize: (options)->
        @layout = new NexposeSites.Layout(collection:options.collection)
        @setMainView(@layout)

        @listenTo @layout, 'table:initialized', =>
          @layout.table.carpenterRadio.on('table:rows:selected',@_triggerRowsSelected)
          @layout.table.carpenterRadio.on('table:rows:deselected',@_triggerRowsSelected)
          @layout.table.carpenterRadio.on('table:row:selected',@_triggerRowsSelected)
          @layout.table.carpenterRadio.on('table:row:deselected',@_triggerRowsSelected)

      onDestroy: () ->
        @layout.table.carpenterRadio.off('table:rows:selected')
        @layout.table.carpenterRadio.off('table:rows:deselected')
        @layout.table.carpenterRadio.off('table:row:selected')
        @layout.table.carpenterRadio.off('table:row:deselected')

      _triggerRowsSelected: () =>
        # Given the acync nature of the nested tables and that none of the existing marionette
        # patterns are a good match, it's easier to ride this event up the dom tree and handle it
        # in a parent controller
        @layout.$el.trigger('site:rows:changed',@layout.table)

    # Reqres Handler to create the Nexpose Sites Controller
    App.reqres.setHandler "nexposeSites:shared", (options={}) ->
      new NexposeSites.Controller options