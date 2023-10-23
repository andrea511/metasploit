define [
  'lib/utilities/navigation'
  'apps/imports/index/index_controller'
  'apps/imports/index/type'
  'css!css/imports'
], ->
  @Pro.module 'ImportsApp', (ImportsApp, App)->

    Index = ImportsApp.Index

    class ImportsApp.Router extends Marionette.AppRouter
      appRoutes:
        ""        : "import"
        "nexpose" : "importNexpose"
        "file"    : "importFile"
        "sonar"   : "importSonar"

    API =
      import: (type=Index.Type.Nexpose) ->
        new ImportsApp.Index.Controller type: type
      importNexpose: ->
        API.import Index.Type.Nexpose
      importFile: ->
        API.import Index.Type.File
      importSonar: ->
        API.import Index.Type.Sonar

    App.addInitializer ->
      new ImportsApp.Router(controller: API)

    # Sets the mainRegion, which is used by default when #show if called
    # without explicitly setting a region.
    App.addRegions
      mainRegion: "#imports-main-region"

    #
    # Route Handler for Import Type Change
    # @example /workspaces/1/imports/new#nexpose
    # @example /workspaces/1/imports/new#file
    #
    App.vent.on "import:typeChange", (type) ->
      App.navigate("##{type}", trigger:false)
