define [
  'css!css/vulns'
  'apps/hosts/hosts_app'
  'lib/utilities/navigation'
  'lib/components/window_slider/window_slider_controller'
], ->

  @Pro.module 'WebVulnsApp', (WebVulnsApp, App) ->

    class WebVulnsApp.Router extends Marionette.AppRouter

      appRoutes:
        "":             "index"
        "webvulns":     "index"
        "webvulns/:id": "show"

    API =

      index: ->
        loading = true
        _.delay((=> if loading then App.execute 'loadingOverlay:show'), 50)
        initProRequire ['apps/web_vulns/index/index_controller'], ->
          loading = false
          App.execute 'loadingOverlay:hide'
          indexController = new WebVulnsApp.Index.Controller

      show: (id) ->
        loading = true
        _.delay((=> if loading then App.execute 'loadingOverlay:show'), 50)

    App.addInitializer =>
      new WebVulnsApp.Router(controller: API)

    # Sets the mainRegion, which is used by default when #show if called
    # without explicitly setting a region.
    App.addRegions
      mainRegion: "#web-vulns-main-region"
