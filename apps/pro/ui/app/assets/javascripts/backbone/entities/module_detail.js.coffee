define [
  'jquery'
  'base_model'
  'base_collection'
], ($) ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    class Entities.ModuleDetail extends App.Entities.Model

      refsOnly: false

      defaults:
        workspace_id: WORKSPACE_ID
        refsOnly: @refsOnly


      url: () =>
        Routes.workspace_module_detail_path(@get('workspace_id'),@get('id'))


    #
    # API
    #

    API =

      getModuleDetail: (opts) ->
        moduleDetail = new Entities.ModuleDetail(opts)
        moduleDetail

    #
    # REQUEST HANDLERS
    #
    App.reqres.setHandler "module:detail:entity", (opts={}) ->
      API.getModuleDetail opts
