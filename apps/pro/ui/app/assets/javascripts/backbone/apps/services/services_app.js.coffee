define [
  'apps/services/index/index_controller'
  'apps/services/delete/delete_controller'
  'lib/utilities/navigation'
  'lib/components/flash/flash_controller'
], ->

  @Pro.module 'ServicesApp', (ServicesApp, App) ->

    class ServicesApp.Router extends Marionette.AppRouter

      appRoutes:
        "":          "index"
        "services":     "index"

    API =
      index: ->
        loading = true
        _.delay((=> if loading then App.execute 'loadingOverlay:show'), 50)
        initProRequire ['apps/services/index/index_controller'], ->
          loading = false
          App.execute 'loadingOverlay:hide'
          indexController = new ServicesApp.Index.Controller

      # @see {Delete.Controller#initialize} options
      delete: (options) ->
        new ServicesApp.Delete.Controller options

    App.addInitializer =>
      new ServicesApp.Router(controller: API)

    # Sets the mainRegion, which is used by default when #show if called
    # without explicitly setting a region.
    App.addRegions
      mainRegion: "#services-main-region"

    # @see {Delete.Controller#initialize} options
    App.reqres.setHandler 'services:delete', (options = {}) ->
      API.delete options

    # When a host tag is added, display a flash message
    #
    App.vent.on "host:tag:added",  ->
      App.execute 'flash:display',
        title:   'Host(s) Tagged '
        message: 'The host(s) were successfully tagged.'
