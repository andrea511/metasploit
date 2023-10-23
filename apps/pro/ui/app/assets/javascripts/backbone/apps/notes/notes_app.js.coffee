define [
  'apps/notes/index/index_controller'
  'apps/notes/delete/delete_controller'
  'lib/utilities/navigation'
], ->

  @Pro.module 'NotesApp', (NotesApp, App) ->

    class NotesApp.Router extends Marionette.AppRouter

      appRoutes:
        "":          "index"
        "notes":     "index"

    API =
      index: ->
        loading = true
        _.delay((=> if loading then App.execute 'loadingOverlay:show'), 50)
        initProRequire ['apps/notes/index/index_controller'], ->
          loading = false
          App.execute 'loadingOverlay:hide'
          indexController = new NotesApp.Index.Controller

      # @see {Delete.Controller#initialize} options
      delete: (options) ->
        new NotesApp.Delete.Controller options

    App.addInitializer =>
      new NotesApp.Router(controller: API)

    # Sets the mainRegion, which is used by default when #show if called
    # without explicitly setting a region.
    App.addRegions
      mainRegion: "#notes-main-region"

    # @see {Delete.Controller#initialize} options
    App.reqres.setHandler 'notes:delete', (options = {}) ->
      API.delete options