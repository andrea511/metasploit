define [
  'apps/loots/index/index_controller'
  'apps/loots/delete/delete_controller'
  'lib/utilities/navigation'
], ->

  @Pro.module 'LootsApp', (LootsApp, App) ->

    class LootsApp.Router extends Marionette.AppRouter

      appRoutes:
        "":          "index"
        "loots":     "index"

    API =
      index: ->
        loading = true
        _.delay((=> if loading then App.execute 'loadingOverlay:show'), 50)
        initProRequire ['apps/loots/index/index_controller'], ->
          loading = false
          App.execute 'loadingOverlay:hide'
          indexController = new LootsApp.Index.Controller

      # @see {Delete.Controller#initialize} options
      delete: (options) ->
        new LootsApp.Delete.Controller options

    App.addInitializer =>
      new LootsApp.Router(controller: API)

    # Sets the mainRegion, which is used by default when #show if called
    # without explicitly setting a region.
    App.addRegions
      mainRegion: "#loots-main-region"

    # @see {Delete.Controller#initialize} options
    App.reqres.setHandler 'loots:delete', (options = {}) ->
      API.delete options