define [
  'base_controller'
  'apps/creds/findings/findings_view'
], ->
  @Pro.module "CredsApp.Findings", (Findings, App) ->
    class Findings.PrivateController extends App.Controllers.Application


      initialize: (opts) ->
        {model} = opts
        itemView = new Findings.Private(model: model)
        @setMainView(itemView)


    class Findings.RealmController extends App.Controllers.Application

      initialize: (opts) ->
        {model} = opts
        itemView = new Findings.Realm(model: model)


        @setMainView(itemView)

        @listenTo @_mainView, 'show:hover', ->
          @hoverView = new Findings.RealmHover(model:model)
          @show @hoverView, region: @_mainView.hoverRegion

        @listenTo @_mainView, 'hide:hover', ->
          @hoverView.destroy()
