define [
  'base_layout'
  'base_view'
  'base_itemview'
  'apps/creds/index/templates/index_layout'
  'lib/components/table/table_view'
], () ->
  @Pro.module 'CredsApp.Index', (Index, App, Backbone, Marionette, $, _) ->

    class Index.Layout extends App.Views.Layout
      template: @::templatePath 'creds/index/index_layout'

      regions:
        credsRegion:  '#creds-region'
        filterRegion: '.filter-region'

      #
      # Update the total creds indicator pill in the header.
      #
      # @param count [Number] the new count of total creds
      #
      # @return [void]
      updateCredsTotal: (count) ->
        $('#total-count', @$el).html count

      setCarpenterChannel: (@channel) ->
        @channel.on 'total_records:change', @updateCredsTotal

      onBeforeDestroy: ->
        @channel.off 'total_records:change'

