define [
  'css!css/vulns'
  'apps/hosts/hosts_app'
  'lib/utilities/navigation'
  'apps/vulns/delete/delete_controller'
  'lib/shared/nexpose_push/nexpose_push_controllers'
  'lib/components/window_slider/window_slider_controller'
], ->

  @Pro.module 'VulnsApp', (VulnsApp, App) ->

    class VulnsApp.Router extends Marionette.AppRouter

      appRoutes:
        "":          "index"
        "vulns":     "index"
        "vulns/:id": "show"

    API =

      index: ->
        # If the route is actually workspaces/:workspace_id/vulns/:vuln_id, redirect to show
        if window.gon?.route == 'show'
          @show(window.gon.id)
          return false

        loading = true
        _.delay((=> if loading then App.execute 'loadingOverlay:show'), 50)
        initProRequire ['apps/vulns/index/index_controller'], ->
          loading = false
          App.execute 'loadingOverlay:hide'
          indexController = new VulnsApp.Index.Controller

      show: (id) ->
        loading = true
        _.delay((=> if loading then App.execute 'loadingOverlay:show'), 50)

        window.VULN_ID = id

        initProRequire [
          'apps/vulns/show/show_controller'
        ], (ShowController) ->
          loading = false
          App.execute 'loadingOverlay:hide'
          controller = new VulnsApp.Show.Controller(
            id: id ? window.VULN_ID,
            workspace_id: window.WORKSPACE_ID
          )

      # @see {Delete.Controller#initialize} options
      delete: (options) ->
        new VulnsApp.Delete.Controller options


    App.addInitializer =>
      new VulnsApp.Router(controller: API)

    # Sets the mainRegion, which is used by default when #show if called
    # without explicitly setting a region.
    App.addRegions
      mainRegion: "#vulns-main-region"

    # @see {Delete.Controller#initialize} options
    App.reqres.setHandler 'vulns:delete', (options = {}) ->
      API.delete options
