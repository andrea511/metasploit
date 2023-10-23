define [
  'base_controller',
  'apps/task_chains/index/index_view'
  'lib/components/modal/modal_controller'
], ->
  @Pro.module 'TaskChainsApp.Index', (Index, App, Backbone, Marionette, jQuery, _) ->
    class Index.Controller extends App.Controllers.Application

      initialize: (options) ->
        { taskChains, @legacyChains } = options
        taskChains or= App.request 'task_chains:entities'

        @layout = @getLayoutView()

        @listenTo @layout, "show", =>
          @listRegion taskChains
          @_showLegacyWarning()

        @show @layout

      #
      # Private Methods
      #
      _showLegacyWarning: ->
        if @legacyChains.length > 0
          view = new Index.LegacyWarningView(model: new Backbone.Model(legacyChains:@legacyChains))

          App.execute 'showModal', view,
            modal:
              title: 'Task Chain Warning'
              description: ''
              width: 600
              height: 218 + 22*@legacyChains.length
            buttons: [
              {name: 'OK', class: 'btn primary'}
            ]


      #
      # REGION INITIALIZERS
      #
      listRegion: (taskChains) ->
        listView = @getListView taskChains
        @layout.listRegion.show listView

      #
      # VIEW ACCESSORS
      #
      getLayoutView: ->
        new Index.Layout

      getListView: (taskChains) ->
        new Index.List
          collection: taskChains
