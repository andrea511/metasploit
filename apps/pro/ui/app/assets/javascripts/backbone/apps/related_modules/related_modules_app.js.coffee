define [
  'css!css/vulns'
  'apps/hosts/hosts_app'
  'lib/utilities/navigation'
  'lib/components/window_slider/window_slider_controller'
], ->

  @Pro.module 'RelatedModulesApp', (RelatedModulesApp, App) ->

    class RelatedModulesApp.Router extends Marionette.AppRouter

      appRoutes:
        "":                "index"
        "related_modules": "index"

    API =

      index: ->
        loading = true
        _.delay((=> if loading then App.execute 'loadingOverlay:show'), 50)
        initProRequire ['apps/related_modules/index/index_controller'], ->
          loading = false
          App.execute 'loadingOverlay:hide'
          indexController = new RelatedModulesApp.Index.Controller


    App.addInitializer =>
      new RelatedModulesApp.Router(controller: API)

    # Sets the mainRegion, which is used by default when #show if called
    # without explicitly setting a region.
    App.addRegions
      mainRegion: "#related-modules-main-region"
